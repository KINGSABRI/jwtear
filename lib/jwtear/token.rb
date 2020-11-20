require_relative 'jws'
require_relative 'jwe'

module JWTear
  class Token
    include JWTear::Helpers::Extensions::Print

    def initialize
      @jws = JWS.new
      @jwe = JWE.new
    end

    # parse
    #   An interface for JWS and JWE parse operation.
    # @param token [String]
    #
    # @return [JWS|JWE]
    def parse(token)
      token_segments = token.split('.').size
      if token_segments <= 3 # JWS
        @jws.parse(token)
      else  # JWE
        @jwe.parse(token)
      end
    rescue Exception => e
      print_error "#{method(__method__).owner}##{__method__} : Unknown Exception"
      print_warning 'Please report the issue to: https://github.com/KINGSABRI/jwtear/issues'.underline
      puts e.full_message
      exit!
    end

    # generate
    #   An interface for JWS and JWE token generation operation.
    # @param type [Symbol]
    # @param header [JSON]
    # @param payload [JSON]
    # @param key [String]
    #
    # @example
    #   token = JWTear::Token.new
    #   token.generate(:jws, header: '{"alg":"HS256","typ":"JWT"}', payload: '{"user":"admin"}', key: "P@ssw0rd123")
    #
    # @return [JWS | JWE]
    def generate(type, header:, payload:, key:)
      case type
      when :jws
        @jws.generate_jws(header:header , payload:payload , key:key)
      when :jwe
        @jwe.generate_jwe(header:header , payload:payload , key:key)
      else
        print_error "Unknown type: #{type}"
        raise
      end
    rescue JSON::ParserError => e
      print_error "Unexpected Token."
      puts e.message
    rescue Exception => e
      method = method(__method__)
      print_error "Unknown Exception: #{method.owner}##{method.name}"
      print_warning 'Please report the issue to: https://github.com/KINGSABRI/jwtear/issues'.underline
      puts e.full_message
      exit!
    end
  end
end

