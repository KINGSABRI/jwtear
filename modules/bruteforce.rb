module JWTear
  module JWTModule

    class BruteForce

      attr_accessor :token
      attr_accessor :word_list
      attr_accessor :option_parser, :options
      def initialize
        # check_gem
        # @word_list = File.open(wordlist).
        #                    each_line(chomp: true).
        #                    map(&:strip).
        #                    reject(&:nil?).
        #                    reject(&:empty?).lazy
        # @token = nil
        #
        # @options = {}
        # @option_parser = OptionParser.new do |opts|
        #   opts.banner = "Usage: -m MODULE <options>"
        #   opts.on("-l", "--wordlist FILE", "password list file") {|v| @options[:list] = v}
        #   opts.on("-h", "--help", "Show this help message") {@option_parser; exit!}
        # end.parse!

      end

      # def check_gem
      #   begin
      #     require 'celluloid'
      #   rescue LoadError
      #     puts "[x] required gem is missing: please run the following"
      #     puts "gem install celluloid"
      #     exit 1
      #   end
      # end

      def self.description
        {
            name: 'BruteForce',
            banner: "Brute-force signature to get the 'Key/Password'."
        }
      end

      def help
        @options = {}
        @option_parser = OptionParser.new
        @option_parser.banner = "Brute-force signature to get the 'Key/Password'."
        self
      end








      def run
        puts "I'm burtefocing now!!!!!"
      end

    end

  end
end