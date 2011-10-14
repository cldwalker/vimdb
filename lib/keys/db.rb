require 'pstore'

module Keys
  class DB
    class << self; attr_accessor :db_file; end
    self.db_file = Dir.home + '/.keys.pstore'

    def self.keys(reload = false)
      File.exists?(db_file) && !reload ? fetch_keys : create_keys
    end

    def self.fetch_keys
      db = PStore.new(db_file)
      db.transaction(true) { db[:vim] }
    end

    def self.create_keys
      db = PStore.new(db_file)
      db.transaction do
        db[:vim] = Vim.create
      end
    end
  end
end
