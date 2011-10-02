class Keys::Runner < Thor
  method_options :plugins_dir => 'plugins', %w{--field -f} => 'key'
  desc 'list [QUERY]', 'List keys'
  def list(query=nil)
    results = query.nil? ? keys : begin
      keys.select {|e| e[options[:field].to_sym] =~ /#{query}/ }
    end
    require 'hirb'
    puts Hirb::Helpers::Table.render(results,
     :fields => [:key, :mode, :plugin, :file], :sort => options[:field].to_sym)
  end

  private

  def generate_keymap_file
    require 'tempfile'
    file = Tempfile.new('key').path
    system %[ vim -c 'colorscheme default | redir! > #{file} | ] +
      "silent! verbose map | redir END | quit'"
    file
  end

  def keys
    file = generate_keymap_file
    lines = File.read(file).strip.split("\n")
    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      key = {}

      file = arr[1].to_s[%r{Last set from (\S+)}, 1]
      plugin = file.to_s[%r{#{options[:plugins_dir]}/([^/]+)\S+}, 1]
      next if file.nil?
      key[:plugin] = plugin if plugin
      key[:file]   = file if file

      key[:key]  = arr[0][/^\S*\s+(\S+)/, 1]
      key[:mode] = arr[0][/^[nvosx]+/] || 'nvosx'
      key
    end.compact
  end
end
