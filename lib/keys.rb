require 'thor'

module Keys
  autoload :Runner, 'keys/runner'
  autoload :User,   'keys/user'
  autoload :DB,     'keys/db'
  autoload :App,    'keys/app'
  autoload :Vim,    'keys/vim'

  class << self; attr_accessor :default_app; end
  self.default_app = 'vim'

  def self.user(app = nil, db = DB.new)
    @user ||= User.new(App.instance(app || default_app), db)
  end
end
