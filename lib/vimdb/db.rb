require 'pstore'

module Vimdb
  class DB
    attr_accessor :file
    def initialize(file = ENV['VIMDB_DB'] || Dir.home + '/.vimdb.pstore')
      @file = file
      @db = PStore.new(@file)
    end

    def get(key)
      @db.transaction(true) { @db[key] }
    end

    def set(key, value)
      @db.transaction { @db[key] = value }
    end
  end
end
