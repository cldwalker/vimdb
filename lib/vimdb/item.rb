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
      new_items = items
      if query
        query = Regexp.escape(query) unless options[:regexp]
        regex = Regexp.new(query, options[:ignore_case])

        new_items = if options[:all]
          items.select {|item|
            fields.any? {|field| item[field] =~ regex }
          }
        else
          items.select {|e| e[options[:field].to_sym] =~ regex }
        end

        yield(new_items) if block_given?
        new_items = items - new_items if options[:not]
      end
      new_items
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

    private

    def vim(*cmds)
      system %[#{Vimdb.vim} -c 'colorscheme default | #{cmds.join(' | ')} | qa']
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
