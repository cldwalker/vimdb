module Keys
  class User
    def initialize(app, db)
      @app, @db = app, db
      @db_exists = File.exists?(@db.file)
    end

    def keys
      @db_exists ? @db.get(@app.key) :
        @db.set(@app.key, @app.create).tap { @db_exists = true }
    end

    def search(query, options = {})
      results = @app.search(keys, query, options)
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
