module JWTear
  # JWS
  #   Takes a parsed token from JSON::JWT#decode
  #
  class JWS
    include JWTear::Helpers::Extensions::Print

    attr_accessor :header, :payload, :signature,
                  :typ, :cty, :alg, :kid, :jku,
                  :iss, :sub, :iat, :exp, :aud, :hd,
                  :azp, :email, :at_hash, :email_verified

    # parse
    #   is a basic parser for JWS token
    #
    # @param token [String]
    #   parsed token string
    #
    # @return [Self]
    #
    def parse(token)
      jwt = JSON::JWT.decode(token, :skip_verification)
      @header    = jwt.header
      @payload   = jwt.to_h
      @signature = jwt.signature
      @alg       = @header["alg"]
      @typ       = @header["typ"]
      @cty       = @header["cty"]
      @kid       = @header["kid"]
      @jku       = @header["jku"]
      @iat       = @payload["iat"]
      self
    rescue JSON::JWT::InvalidFormat => e
      print_error e.message
      puts token
      exit!
    rescue Exception => e
      puts e.full_message
    end

    def to_json_presentation
      "#{@header.to_json}" + "●" + "#{@payload.to_json}" + "●" + "#{Base64.urlsafe_encode64(@signature, padding: false)}"
    end

    # generate_jws
    #   generate JWS token
    #
    # @param header [JSON]
    # @param payload [JSON]
    # @param key [String]
    #
    # @return [String] the generated token
    #
    def generate_jws(header:, payload:, key:)
      jwt = JSON::JWT.new(JSON.parse(payload, symbolize_names: true))
      jwt.header = JSON.parse(header, symbolize_names: true)
      handle_signing(jwt, key)
    rescue JSON::JWS::UnexpectedAlgorithm => e
      puts "Unexpected algorithm '#{jwt.header[:alg]}'."
      puts e.message
      exit!
    end
    
    private

    # handle_signing
    #   Handles the algorithm 'none'.
    # @param jwt [JSON]
    # @param key [String]
    #
    def handle_signing(jwt, key=nil)
      if jwt.alg =~ /none/i
        jwt.to_s
      else
        raise JSON::JWS::UnexpectedAlgorithm.new("Encryption algorithm '#{jwt.alg}' requires key.") if key.nil?
        jwt.sign(key).to_s
      end
    end
  end
end
