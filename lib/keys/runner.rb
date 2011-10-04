class Keys::Runner < Thor
  method_option :plugins_dir, :type => :string, :desc => "directory for vim plugins"
  method_option :field, :default => 'key', :desc => 'field to query', :aliases => '-f'
  method_option :reload, :type => :boolean, :desc => 'reloads keys'
  method_option :sort, :type => :string, :desc => 'sort by field', :aliases => '-s'
  method_option :reverse_sort, :type => :boolean, :aliases => '-r'
  desc 'list [QUERY]', 'List keys'
  def list(query=nil)
    Keys::VimKeys.plugins_dir = options[:plugins_dir] if options[:plugins_dir]
    keys = Keys::DB.keys(options[:reload])
    keys.select! {|e| e[options[:field].to_sym] =~ /#{query}/ } if query
    sort = options[:sort] || options[:field]
    keys.sort_by! {|e| e[sort.to_sym] || '' }
    keys.reverse! if options[:reverse_sort]

    require 'hirb'
    puts Hirb::Helpers::Table.render(keys,
     :fields => [:key, :mode, :plugin, :action])
  end
end
