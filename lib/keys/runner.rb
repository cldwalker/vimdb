require 'hirb'

class Keys::Runner < Thor
  def self.start(*args)
    rc = ENV['KEYSRC'] || '~/.keysrc'
    begin
      load(rc) if File.exists?(File.expand_path(rc))
    rescue StandardError, SyntaxError, LoadError => err
      warn "Error while loading #{rc}:\n"+
        "#{err.class}: #{err.message}\n    #{err.backtrace.join("\n    ")}"
    end
    super
  end

  method_option :field, :default => 'key', :desc => 'field to query', :aliases => '-f'
  method_option :reload, :type => :boolean, :desc => 'reloads keys'
  method_option :sort, :type => :string, :desc => 'sort by field', :aliases => '-s'
  method_option :reverse_sort, :type => :boolean, :aliases => '-R'
  method_option :ignore_case, :type => :boolean, :aliases => '-i'
  method_option :regexp, :type => :boolean, :aliases => '-r', :desc => 'query is a regexp'
  method_option :app, :type => :string, :aliases=>'-a', :desc => 'app to search'
  method_option :mode, :type => :string, :desc => 'vim only: search by mode, multiple modes are ORed', :aliases => '-m'
  desc 'list [QUERY]', 'List keys of an app'
  def list(query=nil)
    Keys.user.reload if options[:reload]
    Keys.app(options[:app]) if options[:app]
    keys = Keys.user.keys

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

    puts Hirb::Helpers::Table.render(keys, fields: Keys.app.display_fields)
  end

  desc 'info', 'Prints info about app'
  def info
    puts Keys.app.info
  end
end
