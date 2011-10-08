require 'hirb'

class Keys::Runner < Thor
  method_option :plugins_dir, :type => :string, :desc => "directory for vim plugins"
  method_option :field, :default => 'key', :desc => 'field to query', :aliases => '-f'
  method_option :reload, :type => :boolean, :desc => 'reloads keys'
  method_option :sort, :type => :string, :desc => 'sort by field', :aliases => '-s'
  method_option :reverse_sort, :type => :boolean, :aliases => '-R'
  method_option :ignore_case, :type => :boolean, :aliases => '-i'
  method_option :regexp, :type => :boolean, :aliases => '-r', :desc => 'query is a regexp'
  method_option :mode, :type => :string, :desc => 'search by mode, multiple modes are ORed', :aliases => '-m'
  desc 'list [QUERY]', 'List keys'
  def list(query=nil)
    Keys::VimKeys.plugins_dir = options[:plugins_dir] if options[:plugins_dir]
    keys = Keys::DB.keys(options[:reload])

    if query
      query = Regexp.escape(query) unless options[:regexp]
      regex = Regexp.new(query, options[:ignore_case])
      keys.select! {|e| e[options[:field].to_sym] =~ regex }
    end
    if options[:mode]
      keys.select! do |key|
        options[:mode].split('').any? {|m| key[:mode].include?(m) }
      end
    end

    sort = options[:sort] || options[:field]
    keys.sort_by! {|e| e[sort.to_sym] || '' }
    keys.reverse! if options[:reverse_sort]

    puts Hirb::Helpers::Table.render(keys,
     fields: [:key, :mode, :from, :desc], headers: {:desc => 'desc/action'})
  end
end
