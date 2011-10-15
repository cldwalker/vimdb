require 'thor'

module Keys
  autoload :Runner, 'keys/runner'
  autoload :User,   'keys/user'
  autoload :DB,     'keys/db'
  autoload :App,    'keys/app'
  autoload :Vim,    'keys/vim'

  class << self; attr_accessor :default_app; end
  self.default_app = ENV['KEYS_APP'] || 'vim'

  def self.user(app_name = nil, db = DB.new)
    @user ||= User.new(app(app_name), db)
  end

  def self.app(name = nil)
    @app ||= App.instance(name || default_app)
  end
end
