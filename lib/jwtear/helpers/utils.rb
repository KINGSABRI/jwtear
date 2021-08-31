module JWTear
  module Helpers
    module Utils

      # Check latest version
      def latest_version
        begin
          current_version = JWTear::VERSION
          rubygem_api     = JSON.parse open("https://rubygems.org/api/v1/versions/jwtear.json").read
          remote_version  = rubygem_api.first["number"]
          latest          = remote_version.eql?(current_version)? true : false

          latest ? current_version : remote_version
        rescue Exception => e
          print_bad " Couldn't check the latest version, please check internet connectivity."
          exit!
        end
      end

      # read key as a string or from file(eg. pub_key.pem)
      def read_key(key)
        if File.exist?(key.to_s) && File.file?(key.to_s)
          File.read(File.absolute_path(key))
        else
          key
        end
      end

      # check_dependencies
      #   check dependencies for plugins and throw a gentle error if not installed
      # @param deps [Hash]
      #   The key is the key is the gem name to be installed, the value is library to be require
      # @example
      #   deps = {'async-io' => 'async/ip'}
      #   check_dependencies(deps)
      #
      def check_dependencies(deps={})
        return if deps.empty? or deps.nil?
        missing = []

        deps.each do |gem, lib|
          begin
            require lib
          rescue LoadError
            missing << gem
          end
        end
      ensure
        unless missing.nil? or missing.empty?
          print_error "Missing dependencies!"
          print_warning "Please install as follows:"
          puts "gem install #{missing.join(' ')}"
          exit!
        end
      end

      # JWTear's logo
      def banner
        %Q{\n    888888 888       888 88888888888
      "88b 888   o   888     888
       888 888  d8b  888     888
       888 888 d888b 888     888   .d88b.   8888b.  888d888
       888 888d88888b888     888  d8P  Y8b     "88b 888P"
       888 88888P Y88888     888  88888888 .d888888 888
       88P 8888P   Y8888     888  Y8b.     888  888 888
       888 888P     Y888     888   "Y8888  "Y888888 888
     .d88P                                       v#{JWTear::VERSION}
   .d88P"
  888P"    }
      end
    end
  end
end
