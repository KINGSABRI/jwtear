require 'base64'
require 'json'
require 'digest'
require 'openssl'

require_relative 'jwtear/version'
require_relative 'jwtear/error'
require_relative 'jwtear/jwt'

# require 'base64'
# require 'json'
# require 'digest'
# require 'openssl'
# # require 'jwtear/error'
#
# module JWTear
#   class JWT
#     # @!attribute [rw] token [String]
#     # @!attribute [rw] header [String]
#     # @!attribute [rw] payload [String]
#     attr_accessor :token, :header, :payload
#     # @!attribute [rw] alg [String]
#     # @!attribute [rw] key [String]
#     # @!attribute [rw] data [String]
#     attr_accessor :alg, :key, :data
#     # @!attribute [r] json [JSON]
#     # @!attribute [r] hash [Hash]
#     attr_reader :json, :hash
#     # @!attribute [r] signature [String]
#     # @!attribute [r] rsa_private [String]
#     # @!attribute [r] rsa_public [String]
#     attr_reader :signature, :rsa_private, :rsa_public
#
#     def initialize(token='')
#       @token = token
#       @key   = nil
#     end
#
#     # parse a given token.
#     #   The main use of it is to parse and initiate header, payload, type, alg, signature values
#     # @param token String
#     def parse(token=@token)
#       _token = token.split('.')
#       @header     = JSON.parse(Base64.urlsafe_decode64(_token[0]))
#       @type, @alg = @header['type'], @header['alg']
#       @payload    = JSON.parse(Base64.urlsafe_decode64(_token[1]))
#       @signature  = Base64.urlsafe_decode64(_token[2]) unless (_token[2].nil? or _token[2].empty?)
#       set_hash_and_json
#     end
#
#     # build the hash and Json format from the parsed or generated token
#     def set_hash_and_json
#       @json       = "#{@header.to_json}.#{@payload.to_json}.#{Base64.urlsafe_encode64(@signature, padding: false)}"
#       @hash       = {header: @header, payload: @payload, signature: Base64.urlsafe_encode64(@signature, padding: false)}
#     end
#
#     # generate signature
#     # @param data [String]. 'Base64.encode(header)'.'Base64.encode(payload)'>
#     # @param alg [String] supported algorithms: HS256 HS384, HS512, RS256, RS384, RS512, ES256, ES384, ES512
#     # @param key String
#     def generate_sig(data, alg, key)
#       # puts "[x] From generate_sig:"
#       # pp "data: #{data}"
#       # pp "key: #{key}"
#       # pp "alg: #{alg}"
#       begin
#         # TODO: More Algorithms to be added
#         case alg
#           when /^HS/
#             raise AlgorithmRequiresKeyError if key.nil?
#             digit = /[[:digit:]]+/
#             @signature = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'.sub(digit, alg[digit])), key, data)
#           when /^RS/
#             @rsa_private = OpenSSL::PKey::RSA.generate(2048)
#             @rsa_public  = @rsa_private.public_key
#             @signature   = @rsa_private.sign(OpenSSL::Digest.new(alg.sub('RS', 'sha')), data)
#
#             # FIXME: need to sign using public key
#             cert   = File.open('pub_cert.pem').read
#             @public_key = OpenSSL::PKey::RSA.new(cert)
#             raise 'Not a public certificate' unless public_key.public?
#
#           when /^ES/
#             # TO SOMETHING
#             # TODO: fixme
#             ecdsa_key = OpenSSL::PKey::EC.new('prime256v1')
#             ecdsa_key.generate_key
#             ecdsa_public = OpenSSL::PKey::EC.new(ecdsa_key)
#             ecdsa_public.private_key = nil
#           when /none/i
#             ''
#         else
#           raise "[x] Unsupported Algorithm: #{alg}"
#         end
#       rescue TypeError => e
#         puts "[x] key cannot be nil or empty: Use: '--key SECRET_KEY' option"
#         exit!
#       rescue Exception => e
#         puts e
#         puts e.backtrace
#       end
#     end
#
#     # generate JWT token
#     #   by default, generate_token uses the given json header to detect the algorithm. But it also accept to ignore than
#     #   and force it to you another algorithm.
#     def generate_token
#       # puts "From generate_token:"
#       @header    =  JSON.parse(@header)  unless @header.is_a?(Hash)
#       @payload   =  JSON.parse(@payload) unless @payload.is_a?(Hash)
#       @alg       = @header['alg'] if @alg.nil?
#       # pp "alg: #{@alg}"
#       # pp "key: #{@key}"
#       # puts ""
#       header    = Base64.urlsafe_encode64(@header.to_json, padding: false)
#       payload   = Base64.urlsafe_encode64(@payload.to_json, padding: false)
#       data      = "#{header}.#{payload}"
#       @signature = generate_sig(data, @alg, @key)
#       signature = encode(@signature)
#       token = [header, payload, signature].join('.')
#       parse(token)
#
#       token
#     end
#
#
#     def encode(data)
#       Base64.urlsafe_encode64(data, padding: false)
#     end
#
#     def decode(data)
#       Base64.urlsafe_decode64(data)
#     end
#   end
# end