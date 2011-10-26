class Vimdb::Options < Vimdb::Item
  def fields
    [:name, :alias, :desc]
  end

  def info
    "Created using :help option-list"
  end

  def create
    file = tempfile(:options_help) do |file|
      vim 'silent help option-list', 'exe "normal 2_y}"', 'new',
        'exe "normal p"', "silent! w! #{file}"
    end

    opts = File.read(file).scan(/^'(\S+)'\s*('\S*')?\s*(.*$)/).map do |line|
      { name: line[0], alias: line[1] ? line[1][1..-2] : '', desc: line[2] }
    end
    opts
  end
end
