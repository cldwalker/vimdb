class Keys::VimKeys
  class << self;  attr_accessor :plugins_dir; end
  self.plugins_dir = 'plugins'

  def self.create
    file = generate_map_file
    parse_map_file(file)
  end

  def self.generate_map_file
    require 'tempfile'
    file = Tempfile.new('key').path
    system %[ vim -c 'colorscheme default | redir! > #{file} | ] +
      "silent! verbose map | redir END | quit'"
    file
  end

  def self.parse_map_file(file)
    lines = File.read(file).strip.split("\n")
    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      key = {}

      file = arr[1].to_s[%r{Last set from (\S+)}, 1]
      plugin = file.to_s[%r{#{plugins_dir}/([^/]+)\S+}, 1]
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
