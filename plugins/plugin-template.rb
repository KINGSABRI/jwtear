module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print
    extend JWTear::Helpers::Utils

    # Uncomment the following line to enable the template

    # desc "Plugin short description"
    # long_desc "Plugin long description"
    # command [:template, :pt] do |c|
    #   c.action do |g,o,a|
    #     puts "Hi, I'm a template."
    #   end
    # end

  end

  module Plugin
    class TemplatePlugin
      include JWTear::Helpers::Extensions::Print
      include JWTear::Helpers::Utils

      def initialize
        check_dependencies
      end

    end
  end
end