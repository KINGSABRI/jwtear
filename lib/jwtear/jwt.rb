require 'jwtear/algorithms'
require 'jwtear/utils'

module JWTear
  class JWT
    include JWTear::Extensions
    include JWTear::Algorithms
    include JWTear::Utils

    # @!attribute [rw] token [String] generated or parsed token
    # @!attribute [rw] header [Hash]
    # @!attribute [rw] payload [Hash]
    attr_accessor :token, :header, :payload
    # @!attribute [rw] alg [String] generated or parsed algorithm
    # @!attribute [rw] key [String] given encryption key
    # @!attribute [rw] data [String] given or parsed data
    attr_accessor :alg, :key, :data
    # @!attribute [r] json [JSON] given or parsed json
    # @!attribute [r] hash [Hash] hash result of parsing given or generated json
    attr_reader :json, :hash
    # @!attribute [r] signature [String] generated or parsed signature.
    # @!attribute [r] rsa_private [String] generated private private key
    # @!attribute [r] rsa_public [String] generated or given public key
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
      is_token?(token)
      _token = token.split('.')
      @header     = JSON.parse(decode(_token[0]))
      @type, @alg = @header['type'], @header['alg']
      @payload    = JSON.parse(decode(_token[1]))
      @signature  = decode(_token[2]) unless (_token[2].nil? or _token[2].empty?)
      set_hash_and_json
    end

    # build the hash and Json format from the parsed or generated token
    def set_hash_and_json
      @hash       = {header: @header, payload: @payload, signature: encode(@signature)}
      @json       = "#{@header.to_json}.#{@payload.to_json}.#{encode(@signature)}"
    end

    # generate signature
    #
    # @param data [String]. 'Base64.encode(header)'.'Base64.encode(payload)'>
    # @param alg [String] supported algorithms: @see [Algorithms#supported_algorithms]
    # @param key String
    #
    # @return [Self] the generate signature
    #
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
            @signature = ecdsa(data, alg)
          when /none/i
            @signature = none
          else
            raise AlgorithmUnknownError
        end
      rescue AlgorithmUnknownError
        puts "[x] ".red + "algorithm cannot be nil, empty or unsupported, Use: '--alg ALGORITHM' option"
        puts "[!] ".yellow   + 'Supported Algorithms:'
        supported_algorithms.each_pair do |alg_key, alg_val|
          puts alg_key, alg_val.map{|_alg| "  #{_alg}" }
        end
        exit!
      rescue AlgorithmRequiresKeyError
        puts "[x] ".red + "key cannot be nil or empty, Use: '--key SECRET_KEY' option"
        exit!
      rescue Exception => e
        puts "[x] ".red + "Unknown Exception: generate_sig"
        puts '[!] '.yellow + 'Please report the issue at: https://github.com/KINGSABRI/jwtear/issues'.underline
        puts e
        puts e.backtrace
      end

      self
    end

    # generate JWT token
    #   by default, generate_token uses the given json header to detect the algorithm.
    #   But it also accept to ignore that and force it to you another algorithm.
    #
    # @return [String] the generated token
    #
    def generate_token

      @header   = JSON.parse(@header)  unless @header.is_a?(Hash)
      @payload  = JSON.parse(@payload) unless @payload.is_a?(Hash)
      @alg      = @header['alg'] if @alg.nil?   # if algorithm not forced, take if from the header

      header_encoded    = encode(@header.to_json)
      payload_encoded   = encode(@payload.to_json)
      data              = "#{header_encoded}.#{payload_encoded}"
      signature_encoded = encode(generate_sig(data, @alg, @key).signature)
      token     = [header_encoded, payload_encoded, signature_encoded].join('.')

      set_hash_and_json

      token
    end

  end
end