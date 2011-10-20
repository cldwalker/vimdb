class Vimdb::Commands < Vimdb::Item
  def initialize
    @plugins_dir = 'plugins'
  end

  def create
    cmds = parse_index_file create_index_file
    cmds + parse_command_file(create_command_file)
  end

  def create_index_file
    file = tempfile
    vim 'silent help index.txt', "silent! w! #{file}"
    file
  end

  def parse_index_file(file)
    lines = File.read(file)[/={10,}\n5. EX commands.*/m].split("\n")
    lines = lines.drop_while {|e| e !~ /^\|/ }

    cmds = []
    lines.each do |line|
      if line =~ /^(\S+)\t+(\S+)\t+([^\t]+)$/
        cmd = { name: $2, tag: $1, desc: $3, from: 'default' }
        cmd[:name].sub!(/^:/, '')
        cmds << cmd
      elsif line =~ /^\t+([^\t]+)$/
        cmds[-1][:desc] << ' ' + $1
      end
    end
    cmds
  end

  def create_command_file
    file = tempfile
    vim "redir! > #{file}", 'exe "silent! verbose command"', 'redir END'
    file
  end

  def parse_command_file(file)
    lines = File.read(file).strip.split("\n")

    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      cmd = {}

      cmd[:file] = arr[1].to_s[%r{Last set from (\S+)}, 1] or next
      cmd[:from] = cmd[:file].to_s[%r{/#{@plugins_dir}/([^/]+)\S+}, 1] || 'user'
      cmd[:from] << ' plugin' if cmd[:from] != 'user'
      cmd[:name]  = arr[0][/^(?:[!b" ]+)(\S+)/, 1]
      cmd[:desc]  = arr[0][/^(?:[!b" ]+)\S+\s*(.*)$/, 1]
      cmd
    end.compact
  end

  def display_fields
    [:name, :desc, :from]
  end

  def info
    "Created using index.txt and :command"
  end
end
