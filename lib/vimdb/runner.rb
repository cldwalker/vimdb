require 'boson/runner'
require 'hirb'
ENV['BOSONRC'] = ENV['VIMDB_RC'] || '~/.vimdbrc'

class Vimdb::Runner < Boson::Runner

  def self.common_search_options
    option :reload, :type => :boolean, :desc => 'reloads items'
    option :sort, :type => :string, :desc => 'sort by field'
    option :reverse_sort, :type => :boolean
    option :ignore_case, :type => :boolean
    option :regexp, :type => :boolean, :desc => 'query is a regexp'
    option :not, :type => :boolean, :desc => 'return non-matching results'
    option :all, :type => :boolean, :desc => 'search all fields'
    option :field, :type => :string, :desc => 'field to query'
    option :tab, :type => :boolean, :desc => 'print tab-delimited table'
  end

  common_search_options
  option :mode, :type => :string, :desc => 'search by mode, multiple modes are ORed'
  desc 'List vim keys'
  def keys(query = nil, options={})
    Vimdb.item('keys')
    search_item(query, options)
  end

  common_search_options
  desc 'List vim options'
  def opts(query = nil, options={})
    Vimdb.item('options')
    search_item(query, options)
  end

  common_search_options
  desc 'List vim commands'
  def commands(query = nil, options={})
    Vimdb.item('commands')
    search_item(query, options)
  end

  desc 'Prints info about an item'
  def info(item = nil)
    puts Vimdb.item(item).info
  end

  private
  def search_item(query = nil, options)
    Vimdb.user.reload if options[:reload]
    keys = Vimdb.user.search(query, options)
    puts Hirb::Helpers::Table.render(keys, fields: Vimdb.item.fields, tab: options[:tab])
  end

end
