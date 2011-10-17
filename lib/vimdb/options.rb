class Vimdb::Options < Vimdb::Item
  def display_fields
    [:name, :alias, :desc]
  end

  def info
    "Created using :help option-list"
  end

  def create
    file = '.vimdb.temp'
    # TODO: tempfile not working
    #file = Tempfile.new('vim-options').path
    vim 'silent help option-list', 'exe "normal 2_y}"', 'new', 'exe "normal p"',
      "silent! w! #{file}"

    opts = File.read(file).scan(/^'(\S+)'\s*('\S*')?\s*(.*$)/).map do |line|
      { name: line[0], alias: line[1] ? line[1][1..-2] : '', desc: line[2] }
    end
    File.unlink file
    opts
  end
end
