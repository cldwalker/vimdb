class Vimdb::Commands < Vimdb::Item
  def initialize
    @plugins_dir = Vimdb.plugins_dir
  end

  def create
    cmds = parse_index_file create_index_file
    cmds + parse_command_file(create_command_file)
  end

  def create_index_file
    tempfile(:commands_index) do |file|
      vim 'silent help index.txt', "silent! w! #{file}"
    end
  end

  def parse_index_file(file)
    lines = File.read(file)[/={10,}\n5. EX commands.*/m].split("\n")

    cmds = []
    lines.each do |line|
      if line =~ /^(\S+)\t+(\S+)\t+([^\t]+)$/
        cmd = { name: $2, tag: $1, desc: $3, from: 'default' }
        cmd[:name].sub!(/^:/, '')
        if cmd[:name][/^(.*)\[([a-z]+)\]$/]
          cmd[:alias] = $1
          cmd[:name] = $1 + $2
        end
        cmds << cmd
      elsif line =~ /^\t+([^\t]+)$/
        cmds[-1][:desc] << ' ' + $1
      end
    end
    cmds
  end

  def create_command_file
    tempfile(:commands_command) do |file|
      vim "redir! > #{file}", 'exe "silent! verbose command"', 'redir END'
    end
  end

  def parse_command_file(file)
    lines = File.read(file).strip.split("\n")
    completions = Regexp.union('dir', 'file', 'buffer', 'shellcmd', 'customlist')

    lines.slice_before {|e| e !~ /Last set/ }.map do |arr|
      cmd = {}

      cmd[:file] = arr[1].to_s[%r{Last set from (\S+)}, 1] or next
      match = cmd[:file].to_s.match(%r{/#{@plugins_dir}/(?<plugin>[^/]+)})
      cmd[:from] = match ? match[:plugin] + ' plugin' : 'user'
      cmd[:name]  = arr[0][/^(?:[!b" ]+)(\S+)/, 1]
      cmd[:desc]  = arr[0][/^(?:[!b" ]+)\S+\s*(.*)$/, 1]
      if cmd[:desc][/^(\*|\+|\?|\d)\s+(\dc?|%|\.)?\s*(#{completions})?\s*(.*)/]
        cmd[:args] = $1
        cmd[:desc] = $4
      end
      cmd
    end.compact
  end

  def display_fields
    [:name, :alias, :from, :desc]
  end

  def info
    "Created using index.txt and :command"
  end
end
