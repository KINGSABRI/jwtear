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
    #     print_h1 "Plugin template"
    #     print_good "Hi, I'm a template."
    #     template = TemplatePlugin.new
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
      # ..code...
    end
  end
end