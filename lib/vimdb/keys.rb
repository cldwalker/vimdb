class Vimdb::Keys < Vimdb::Item
  class << self; attr_accessor :config end
  self.config = {
    modifiers: {'<Esc>' => 'E'},
    mode_map: {'!' => 'ci', 'v' => 'vs', 'x' => 'v', 'l' => 'ci'},
  }

  def initialize
    @modifiers, @mode_map = self.class.config.values_at(:modifiers, :mode_map)
    @plugins_dir = Vimdb.plugins_dir
  end

  def create
    keys = parse_index_file create_index_file
    @leader ||= get_leader
    @modifiers[@leader] ||= 'L'
    keys + parse_map_file(create_map_file)
  end

  def search(keys, query, options = {})
    keys = super
    if options[:mode]
      keys.select! do |key|
        options[:mode].split('').any? {|m| key[:mode].include?(m) }
      end
    end
    keys
  end

  def info
    "Created using index.txt and :map"
  end

  def display_fields
    [:key, :mode, :from, :desc]
  end

  private

  def get_leader
    file = tempfile
    leader_cmd = %[silent! echo exists("mapleader") ? mapleader : ""]
    vim "redir! > #{file}", leader_cmd, 'redir END'
    leader = File.readlines(file).last.chomp
    {' ' => '<Space>', '' => '\\'}[leader] || leader
  end

  def create_index_file
    file = tempfile
    vim 'silent help index.txt', "silent! w! #{file}"
    file
  end

  def parse_index_file(file)
    lines = File.read(file).split("\n")
    sections = lines.slice_before(/^={10,}/).to_a
    header_modes = [
      ['1. Insert mode', 'i'], ['2.1', 'ovs'], ['2.', 'n'],
      ['3. Visual mode', 'vs'], ['4. Command-line editing', 'c']
    ]

    keys = []
    # skip intro and last Ex section
    sections[1..-2].each do |section_lines|
      mode = header_modes.find {|k,v|
        section_lines[1] =~ Regexp.new('^' + Regexp.quote(k))
      }.to_a[1] || '?'

      #drop section header
      section_lines = section_lines.drop_while {|e| e !~ /^\|/ }

      section_lines.each do |e|
        cols = e.split(/\t+/)
        if cols.size >= 3
          key = translate_index_key cols[-2]
          keys << {mode: mode, key: key, desc: cols[-1].strip, :from => 'default'}
        # add desc from following lines
        elsif cols.size == 2 && cols[0] == ''
          keys[-1][:desc] += ' ' + cols[1].strip
        # else
        # TODO: parse few edge cases
        end
      end
    end
    keys
  end

  def translate_index_key(key)
    key.gsub(/CTRL-(\S)/) {|s| "C-#{$1.downcase}" }
  end

  def create_map_file
    file = tempfile
    vim "redir! > #{file}", "silent! verbose map", "silent! verbose map!",
      'redir END'
    file
  end

  def parse_map_file(file)
    lines = File.read(file).strip.split("\n")
    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      key = {}

      key[:file] = arr[1].to_s[%r{Last set from (\S+)}, 1] or next
      key[:from] = key[:file].to_s[%r{/#{@plugins_dir}/([^/]+)\S+}, 1] || 'user'
      key[:from] += ' plugin' if key[:from] != 'user'

      key[:key]  = arr[0][/^\S*\s+(\S+)/, 1]
      next if key[:key][/^(<Plug>|<SNR>)/]
      key[:key] = translate_map_key(key[:key])

      key[:desc] = arr[0][/^\S*\s+\S+\s+(.*)$/, 1]
      key[:mode] = (mode = arr[0][/^[nvsxo!ilc]+/]) ?
        @mode_map[mode] || mode : 'nvso'
      key
    end.compact
  end

  def translate_map_key(key)
    if match = /^(?<modifier>#{Regexp.union(*@modifiers.keys)})(?<first>\S)(?<rest>.*$)/.match(key)
      rest = match[:rest].empty? ? '' : ' ' + match[:rest]
      "#{@modifiers[match[:modifier]]}-#{match[:first]}" + rest
    elsif match = /^<(?<ctrl>C-[^>])>(?<rest>.*$)/.match(key)
      rest = match[:rest].empty? ? '' :
        ' ' + match[:rest].gsub(/<(C-[^>])>/, '\1')
      (match[:ctrl] + rest).gsub(/C-([A-Z])/) {|s| "C-#{$1.downcase}" }
    else
      key
    end
  end
end
