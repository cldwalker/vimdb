module Keys
  class App
    def self.inherited(mod)
      (@descendants ||= []) << mod
    end

    def self.load_app(name)
      require "keys/#{name}"
    rescue LoadError
    end

    def self.instance(name)
      load_app(name)
      app = @descendants.find {|e| e.app_name == name } or
        abort "App '#{name}' not found"
      app.new
    end

    def self.app_name
      name[/\w+$/].downcase
    end

    # key used to store app in DB
    def key
      self.class.app_name.to_sym
    end

    def create
      raise NotImplementedError
    end

    def info
      raise NotImplementedError
    end
  end
end
