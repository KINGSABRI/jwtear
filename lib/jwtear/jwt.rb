require 'jwtear/algorithms'
require 'jwtear/utils'

module JWTear
  class JWT
    include JWTear::Extensions
    include JWTear::Algorithms
    include JWTear::Utils

    # @!attribute [rw] token [String]
    # @!attribute [rw] header [String]
    # @!attribute [rw] payload [String]
    attr_accessor :token, :header, :payload
    # @!attribute [rw] alg [String]
    # @!attribute [rw] key [String]
    # @!attribute [rw] data [String]
    attr_accessor :alg, :key, :data
    # @!attribute [r] json [JSON]
    # @!attribute [r] hash [Hash]
    attr_reader :json, :hash
    # @!attribute [r] signature [String]
    # @!attribute [r] rsa_private [String]
    # @!attribute [r] rsa_public [String]
    attr_reader :signature, :rsa_private, :rsa_public

    def initialize(token='')
      @token = token
      @key   = nil
    end

    # parse a given token.
    #   The main use of it is to parse and initiate header, payload, type, alg, signature values
    #
    # @param token String
    def parse(token=@token)
      _token = token.split('.')
      @header     = JSON.parse(Base64.urlsafe_decode64(_token[0]))
      @type, @alg = @header['type'], @header['alg']
      @payload    = JSON.parse(Base64.urlsafe_decode64(_token[1]))
      @signature  = Base64.urlsafe_decode64(_token[2]) unless (_token[2].nil? or _token[2].empty?)
      set_hash_and_json
    end

    # build the hash and Json format from the parsed or generated token
    def set_hash_and_json
      @json       = "#{@header.to_json}.#{@payload.to_json}.#{Base64.urlsafe_encode64(@signature, padding: false)}"
      @hash       = {header: @header, payload: @payload, signature: Base64.urlsafe_encode64(@signature, padding: false)}
    end

    # generate signature
    #
    # @param data [String]
    #   'Base64.encode(header)'.'Base64.encode(payload)'>
    # @param alg [String]
    #   supported algorithms: HS256 HS384, HS512, RS256, RS384, RS512, ES256, ES384, ES512
    # @param key String
    def generate_sig(data, alg, key)
      begin
        case alg
          when /^HS/
            @signature = sha(data, alg, key)
          when /^RS/
            rsa = rsa(data, alg)
            @rsa_public  = rsa[:public_key]
            @rsa_private = rsa[:private_key]
            @signature   = rsa[:signature]
          when /^ES/
            ecdsa(data, alg)
          when /none/i
            none
          else
            raise AlgorithmUnknownError
        end
      rescue AlgorithmUnknownError
        puts "[x] ".red.bold + "algorithm cannot be nil, empty or unsupported, Use: '--alg ALGORITHM' option"
        puts "[!] ".yellow   + 'Supported Algorithms:'
        supported_algorithms.each_pair do |alg_key, alg_val|
          puts alg_key, alg_val.map{|_alg| "  #{_alg}" }
        end
        exit!
      rescue AlgorithmRequiresKeyError
        puts "[x] ".red.bold + "key cannot be nil or empty, Use: '--key SECRET_KEY' option"
        exit!
      rescue Exception => e
        puts "[x] ".red.bold + "Unknown Exception: generate_sig"
        puts e
        puts e.backtrace
      end

      self
    end

    # generate JWT token
    #   by default, generate_token uses the given json header to detect the algorithm. But it also accept to ignore than
    #   and force it to you another algorithm.
    def generate_token
      @header    =  JSON.parse(@header)  unless @header.is_a?(Hash)
      @payload   =  JSON.parse(@payload) unless @payload.is_a?(Hash)
      @alg       = @header['alg'] if @alg.nil?
      header    = Base64.urlsafe_encode64(@header.to_json, padding: false)
      payload   = Base64.urlsafe_encode64(@payload.to_json, padding: false)
      data      = "#{header}.#{payload}"
      @signature = generate_sig(data, @alg, @key).signature
      signature = encode(@signature)
      token = [header, payload, signature].join('.')
      parse(token)

      token
    end

  end
end