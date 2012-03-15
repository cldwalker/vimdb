require 'tempfile'

module Vimdb
  class Item
    def self.inherited(mod)
      (@descendants ||= []) << mod
    end

    def self.instance(name)
      item = @descendants.find {|e| e.item_name == name } or
        abort "Item '#{name}' not found"
      item.new
    end

    def self.item_name
      name[/\w+$/].downcase
    end

    def self.all
      @descendants.map(&:item_name)
    end

    def search(items, query, options = {})
      if query
        query = Regexp.escape(query) unless options[:regexp]
        regex = Regexp.new(query, options[:ignore_case])

        if options[:all]
          items.select! {|item|
            fields.any? {|field| item[field] =~ regex }
          }
        else
          search_field = options[:field] ? options[:field].to_sym : default_field
          items.select! {|item| item[search_field] =~ regex }
        end
      end
      items
    end

    # key used to store item in DB
    def key
      self.class.item_name
    end

    def create
      raise NotImplementedError
    end

    def info
      raise NotImplementedError
    end

    def fields
      raise NotImplementedError
    end

    def default_field
      fields[0]
    end

    private

    def vim(*cmds)
      quote = "'"
      if RUBY_PLATFORM =~ /mswin(?!ce)|mingw|cygwin|bccwin/i
        cmds = cmds.map{|x| x.gsub(/"/,'"""') }
        quote = '"'
      end
      system %[#{Vimdb.vim} -N -u NONE --cmd #{quote}colorscheme default | #{cmds.join(' | ')} | qa#{quote}]
    end

    if ENV['VIMDB_FIXTURE_DIR']
      def tempfile(name)
        File.join ENV['VIMDB_FIXTURE_DIR'], name.to_s
      end
    else
      def tempfile(name)
        file = Tempfile.new(Time.now.to_i.to_s).path
        yield(file)
        file
      end
    end
  end
end

require 'vimdb/keys'
require 'vimdb/options'
require 'vimdb/commands'
