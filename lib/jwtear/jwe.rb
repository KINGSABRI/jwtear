require 'jwe'

module JWTear
  # JWE
  #   Takes a parsed token from JSON::JWT#decode
  #
  class JWE
    include JWTear::Helpers::Extensions::Print

    attr_accessor :header, :encrypted_key, :iv, :cipher_text, :authentication_tag,
                  :kid, :auth_data, :plaintext, :alg, :enc, :zip, :cek,
                  :iss, :sub, :iat

    # parse
    #   is a basic parser for JWE token
    #
    # @param token [String]
    #   parsed token string
    #
    # @return [Self]
    #
    def parse(token)
      jwt = JSON::JWT.decode(token, :skip_decryption, :skip_verification)
      @header             = jwt.header
      @encrypted_key      = jwt.send(:jwe_encrypted_key)
      @iv                 = jwt.iv
      @cipher_text        = jwt.cipher_text
      @authentication_tag = jwt.send(:authentication_tag)
      @algorithm          = jwt.algorithm
      @auth_data          = jwt.auth_data
      @plaintext          = jwt.send(:plain_text)
      @kid                = jwt.kid
      @alg                = @header["alg"]
      @typ                = @header["typ"]
      @cty                = @header["cty"]
      @enc                = @header["enc"]
      @zip                = @header["zip"]
      @iat                = @encrypted_key["iat"]
      @iss                = @encrypted_key["iss"]
      @cek                = @encrypted_key
      self
    rescue JSON::JWS::UnexpectedAlgorithm => e
      puts e.full_message
    rescue JSON::JWT::InvalidFormat => e
      print_error e.message
      puts token
      exit!
    end

    def to_json_presentation
      header = @header
      if is_encrypted?(@encrypted_key)
        encrypted_key = Base64.urlsafe_encode64(@encrypted_key, padding: false)
      else
        encrypted_key = @encrypted_key.to_json
      end
      iv = Base64.urlsafe_encode64(@iv)
      cipher_text = Base64.urlsafe_encode64(@cipher_text, padding: false)
      authentication_tag = Base64.urlsafe_encode64(@authentication_tag, padding: false)

      "#{header.to_json}" + ".".bold +
      "#{encrypted_key}"  + ".".bold +
      "#{iv}"             + ".".bold +
      "#{cipher_text}"    + ".".bold +
      "#{authentication_tag}"
    end

    # generate_jwe
    #   generate JWE token
    #
    # @param header [JSON]
    # @param payload [JSON]
    # @param key [String]
    #
    # @return [String] the generated token
    #
    def generate_jwe(header:, payload:, key:)
      key = OpenSSL::PKey::RSA.new(key)
      jwt = JSON::JWT.new(JSON.parse(payload, symbolize_names: true))
      jwt.header = JSON.parse(header, symbolize_names: true)
      ::JWE.encrypt(payload, key, enc: jwt.header[:enc]) # I had to use this gem as jwe does not support A192GCM AFAIK
    rescue TypeError => e
      print_bad "Invalid data type."
      print_warning "Make sure your public/private key file exists."
    rescue ArgumentError => e
      print_error e.message
      print_warning "Make sure that you have a proper header."
      puts jwt.header
    rescue OpenSSL::PKey::RSAError => e
      print_error "#{e.message} '#{key}'"
      print_warning "Make sure your public/private key file exists."
      exit!
    end

    # is_encrypted?
    #   to check if the given string in a JSON format or its encrypted.
    #   Used mostly with @encrypted_key as it might come in different format.
    # @param item [JSON|STRING]
    #
    # @return [Boolean]
    def is_encrypted?(item)
      JSON.parse item
      false
    rescue JSON::ParserError
      true
    end
  end
end
