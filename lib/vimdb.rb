module Vimdb
  autoload :Runner, 'vimdb/runner'
  autoload :User,   'vimdb/user'
  autoload :DB,     'vimdb/db'
  autoload :Item,   'vimdb/item'
  autoload :Keys,    'vimdb/keys'

  class << self; attr_accessor :default_item; end
  self.default_item = ENV['VIMDB_ITEM'] || 'keys'

  def self.user(item_name = nil, db = DB.new)
    @user ||= User.new(item(item_name), db)
  end

  def self.item(name = nil)
    @item ||= Item.instance(name || default_item)
  end
end
