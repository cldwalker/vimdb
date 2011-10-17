require 'thor'
require 'hirb'

class Vimdb::Runner < Thor
  def self.start(*args)
    rc = ENV['VIMDBRC'] || '~/.vimdbrc'
    begin
      load(rc) if File.exists?(File.expand_path(rc))
    rescue StandardError, SyntaxError, LoadError => err
      warn "Error while loading #{rc}:\n"+
        "#{err.class}: #{err.message}\n    #{err.backtrace.join("\n    ")}"
    end
    super
  end

  method_option :field, :default => 'key', :desc => 'field to query', :aliases => '-f'
  method_option :reload, :type => :boolean, :desc => 'reloads items'
  method_option :sort, :type => :string, :desc => 'sort by field', :aliases => '-s'
  method_option :reverse_sort, :type => :boolean, :aliases => '-R'
  method_option :ignore_case, :type => :boolean, :aliases => '-I'
  method_option :regexp, :type => :boolean, :aliases => '-r', :desc => 'query is a regexp'
  method_option :item, :type => :string, :aliases=>'-i', :desc => 'item to search'
  method_option :mode, :type => :string, :desc => 'search by mode, multiple modes are ORed', :aliases => '-m'
  desc 'keys [QUERY]', 'List vim keys'
  def keys(query=nil)
    Vimdb.user.reload if options[:reload]
    Vimdb.item(options[:item]) if options[:item]
    keys = Vimdb.user.search(query, options)
    puts Hirb::Helpers::Table.render(keys, fields: Vimdb.item.display_fields)
  end

  desc 'info', 'Prints info about an item'
  def info
    puts Vimdb.item.info
  end
end
