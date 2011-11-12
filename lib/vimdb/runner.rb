require 'thor'
require 'hirb'

class Vimdb::Runner < Thor
  def self.start(*args)
    rc = ENV['VIMDB_RC'] || '~/.vimdbrc'
    begin
      load(rc) if File.exists?(File.expand_path(rc))
    rescue StandardError, SyntaxError, LoadError => err
      warn "Error while loading #{rc}:\n"+
        "#{err.class}: #{err.message}\n    #{err.backtrace.join("\n    ")}"
    end
    super
  end

  def self.common_search_options
    method_option :reload, :type => :boolean, :desc => 'reloads items'
    method_option :sort, :type => :string, :desc => 'sort by field', :aliases => '-s'
    method_option :reverse_sort, :type => :boolean, :aliases => '-R'
    method_option :ignore_case, :type => :boolean, :aliases => '-i'
    method_option :regexp, :type => :boolean, :aliases => '-r', :desc => 'query is a regexp'
    method_option :not, :type => :boolean, :aliases => '-n', :desc => 'return non-matching results'
    method_option :all, :type => :boolean, :aliases => '-a', :desc => 'search all fields'
    method_option :field, :type => :string, :desc => 'field to query', :aliases => '-f'
  end

  common_search_options
  method_option :mode, :type => :string, :desc => 'search by mode, multiple modes are ORed', :aliases => '-m'
  desc 'keys [QUERY]', 'List vim keys'
  def keys(query = nil)
    Vimdb.item('keys')
    search_item(query)
  end

  common_search_options
  desc 'opts [QUERY]', 'List vim options'
  def opts(query = nil)
    Vimdb.item('options')
    search_item(query)
  end

  common_search_options
  desc 'commands [QUERY]', 'List vim commands'
  def commands(query = nil)
    Vimdb.item('commands')
    search_item(query)
  end

  desc 'info [ITEM]', 'Prints info about an item'
  def info(item = nil)
    puts Vimdb.item(item).info
  end

  common_search_options
  desc 'tag ITEM TAG', 'Tags a specific item with a tag'
  def tag(query, tag)
    items = Vimdb.user.search(query, options)
    if items.size > 1
      Hirb.enable
      items = Hirb::Menu.render(items, fields: Vimdb.item.fields)
    end
    items.each {|item| Vimdb.user.update_item(item, tag: tag) }
  end

  desc 'tag_list TAG', 'List items in tag'
  def tag_list(tag)
    keys = Vimdb.user.search(tag, field: 'tag')
    puts Hirb::Helpers::Table.render(keys, fields: Vimdb.item.fields << :tag)
  end

  private
  def search_item(query = nil)
    Vimdb.user.reload if options[:reload]
    keys = Vimdb.user.search(query, options)
    puts Hirb::Helpers::Table.render(keys, fields: Vimdb.item.fields)
  end
end
