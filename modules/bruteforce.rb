module JWTear
  module JWTModule

    class BruteForce

      attr_accessor :token
      attr_accessor :word_list
      def initialize(wordlist)
        check_gem
        @word_list = File.open(wordlist).
                           each_line(chomp: true).
                           map(&:strip).
                           reject(&:nil?).
                           reject(&:empty?).lazy
        @token = nil
      end

      def check_gem
        begin
          require 'celluloid'
        rescue LoadError
          puts "[x] required gem is missing: please run the following"
          puts "gem install celluloid"
          exit 1
        end
      end

      def options
        "'Brute-force signature to get the 'Key/Password'. (required for generate-token and generate-sig)'"
      end

      def bruteforce
        puts "I'm burtefocing now!!!!!"
      end

    end

  end
end