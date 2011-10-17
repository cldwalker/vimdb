module Vimdb
  class User
    def initialize(item, db)
      @item, @db = item, db
      @db_exists = File.exists?(@db.file)
    end

    def items
      @db_exists ? @db.get(@item.key) :
        @db.set(@item.key, @item.create).tap { @db_exists = true }
    end

    def search(query, options = {})
      results = @item.search(items, query, options)
      sort = options[:sort] || options[:field]
      results.sort_by! {|e| e[sort.to_sym] || '' }
      results.reverse! if options[:reverse_sort]
      results
    end

    def reload
      @db_exists = false
    end
  end
end
