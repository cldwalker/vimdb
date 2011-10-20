require 'tempfile'

module Vimdb
  class Item
    def self.inherited(mod)
      (@descendants ||= []) << mod
    end

    def self.load_item(name)
      require "vimdb/#{name}"
    rescue LoadError
    end

    def self.instance(name)
      load_item(name)
      item = @descendants.find {|e| e.item_name == name } or
        abort "Item '#{name}' not found"
      item.new
    end

    def self.item_name
      name[/\w+$/].downcase
    end

    def search(items, query, options = {})
      if query
        query = Regexp.escape(query) unless options[:regexp]
        regex = Regexp.new(query, options[:ignore_case])
        items.select! {|e| e[options[:field].to_sym] =~ regex }
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

    def display_fields
      raise NotImplementedError
    end

    private

    def vim(*cmds)
      system %[#{Vimdb.vim} -c 'colorscheme default | #{cmds.join(' | ')} | qa']
    end

    def tempfile
      file = Tempfile.new(Time.now.to_i.to_s).path
    end
  end
end
