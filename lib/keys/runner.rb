class Keys::Runner < Thor
  method_options :plugins_dir => 'plugins', %w{--field -f} => 'key'
  desc 'list [QUERY]', 'List keys'
  def list(query=nil)
    file = generate_map_file
    keys = parse_map_file(file)
    keys.select! {|e| e[options[:field].to_sym] =~ /#{query}/ } if query

    require 'hirb'
    puts Hirb::Helpers::Table.render(keys,
     :fields => [:key, :mode, :plugin, :action], :sort => options[:field])
  end

  private

  def generate_map_file
    require 'tempfile'
    file = Tempfile.new('key').path
    system %[ vim -c 'colorscheme default | redir! > #{file} | ] +
      "silent! verbose map | redir END | quit'"
    file
  end

  def parse_map_file(file)
    lines = File.read(file).strip.split("\n")
    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      key = {}

      file = arr[1].to_s[%r{Last set from (\S+)}, 1]
      plugin = file.to_s[%r{#{options[:plugins_dir]}/([^/]+)\S+}, 1]
      next if file.nil?
      key[:plugin] = plugin if plugin
      key[:file]   = file if file

      key[:key]  = arr[0][/^\S*\s+(\S+)/, 1]
      key[:action] = arr[0][/^\S*\s+\S+\s+(.*)$/, 1]
      key[:mode] = arr[0][/^[nvosx]+/] || 'nvosx'
      key
    end.compact
  end
end
