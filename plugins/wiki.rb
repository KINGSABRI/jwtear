module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print
    extend JWTear::Helpers::Utils

    desc "A JWT wiki for hackers."
    long_desc "Wiki wiki Wiki wiki Wiki wiki Wiki wiki Wiki wiki Wiki wiki"
    command [:wiki, :w] do |c|

      c.desc "Show the wiki page on terminal"
      c.switch [:r, :read], negatable: false

      c.desc "Update wiki from the official repository"
      c.switch [:u, :update], negatable: false

      c.action do |_, options, _|
        options[:update] ? Plugin::Wiki.update : Plugin::Wiki.read
      end
    end
  end

  module Plugin
    class Wiki
      extend JWTear::Helpers::Extensions::Print

      def self.read
        parsed = TTY::Markdown.parse_file('plugins/wiki/README.md', width: 80)
        pager  = TTY::Pager.new
        pager.page(parsed)
      end

      def self.update
        require 'open-uri'
        print_status 'Updating wiki'
        current_wiki = open(File.join( 'wiki', 'README.md')).read
        updated_wiki = open('https://raw.githubusercontent.com/KINGSABRI/jwtear/master/plugins/wiki/README.md').read
        print_good 'Update completed.'
      end
    end
  end
end