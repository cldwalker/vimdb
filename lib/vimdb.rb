module Vimdb
  autoload :Runner, 'vimdb/runner'
  autoload :User,   'vimdb/user'
  autoload :DB,     'vimdb/db'
  autoload :Item,   'vimdb/item'

  class << self; attr_accessor :default_item, :vim, :plugins_dir; end
  self.default_item = ENV['VIMDB_ITEM'] || 'keys'
  self.vim = 'vim'
  self.plugins_dir = 'bundle'

  def self.user(item_name = nil, db = DB.new)
    @user ||= User.new(item(item_name), db)
  end

  def self.item(name = nil)
    @item ||= Item.instance(name || default_item)
  end
end
