class Keys::Runner < Thor
  method_options :plugins_dir => :string, %w{--field -f} => 'key',
    :reload => false
  desc 'list [QUERY]', 'List keys'
  def list(query=nil)
    Keys::VimKeys.plugins_dir = options[:plugins_dir] if options[:plugins_dir]
    keys = Keys::DB.keys(options[:reload])
    keys.select! {|e| e[options[:field].to_sym] =~ /#{query}/ } if query

    require 'hirb'
    puts Hirb::Helpers::Table.render(keys,
     :fields => [:key, :mode, :plugin, :action], :sort => options[:field])
  end
end
