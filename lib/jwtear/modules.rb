module JWTear
  module JWTModules
    MODULES_PATH = Dir.glob("#{File.dirname(__FILE__)}/../../modules/*.rb")
    # p MODULES_PATH

    def self.load_modules
      MODULES_PATH.each do |_module|
        require _module
      end
    end

    def self.list_modules
      # @modules = JWTear::JWTModule.constants
      # .select {|c| MyModule.const_get(c).is_a? Class}
      # p JWTear::JWTModule.const_get(:BruteForce)
      # @modules = JWTear::JWTModule.constants.select {|c| JWTear::JWTModule.const_get(c).is_a? Class}
      @modules = JWTear::JWTModule.constants.map do |c|
        _class = JWTear::JWTModule.const_get(c)
        _class if _class.is_a? Class
      end
    end

  end
end
