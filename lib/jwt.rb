require 'base64'
require 'json'
require 'digest'
require 'openssl'

# +--------------+-------------------------------+--------------------+
# | "alg" Param  | Digital Signature or MAC      | Implementation     |
# | Value        | Algorithm                     | Requirements       |
# +--------------+-------------------------------+--------------------+
# | HS256        | HMAC using SHA-256            | Required           |
# | HS384        | HMAC using SHA-384            | Optional           |
# | HS512        | HMAC using SHA-512            | Optional           |
# | RS256        | RSASSA-PKCS1-v1_5 using       | Recommended        |
# |              | SHA-256                       |                    |
# | RS384        | RSASSA-PKCS1-v1_5 using       | Optional           |
# |              | SHA-384                       |                    |
# | RS512        | RSASSA-PKCS1-v1_5 using       | Optional           |
# |              | SHA-512                       |                    |
# | ES256        | ECDSA using P-256 and SHA-256 | Recommended+       |
# | ES384        | ECDSA using P-384 and SHA-384 | Optional           |
# | ES512        | ECDSA using P-521 and SHA-512 | Optional           |
# | PS256        | RSASSA-PSS using SHA-256 and  | Optional           |
# |              | MGF1 with SHA-256             |                    |
# | PS384        | RSASSA-PSS using SHA-384 and  | Optional           |
# |              | MGF1 with SHA-384             |                    |
# | PS512        | RSASSA-PSS using SHA-512 and  | Optional           |
# |              | MGF1 with SHA-512             |                    |
# | none         | No digital signature or MAC   | Optional           |
# |              | performed                     |                    |
# +--------------+-------------------------------+--------------------+
module JWTear
  class JWT
    attr_accessor :token, :header, :payload
    attr_accessor :alg, :key, :data
    attr_reader :signature, :alg_map, :json, :hash
    def initialize(token='')
      @token = token
    end

    def parse(token=@token)
      _token = token.split('.')
      @header     = JSON.parse(Base64.urlsafe_decode64(_token[0]))
      @type, @alg = @header['type'], @header['alg']
      @payload    = JSON.parse(Base64.urlsafe_decode64(_token[1]))
      @signature  = Base64.urlsafe_decode64(_token[2])
      @json       = "#{@header}.#{@payload}.#{signature}"
      @hash       = {header: @header, payload: @payload, signature: @signature}
    end

    def generate_sig(data, alg, key='s3cr3t')
      begin
        # TODO: More Algorithms to be added
        case alg
        when 'HS256'
          OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, data)
        when 'RS256'
          key = OpenSSL::PKey::RSA.new
          @signature = key.sign(OpenSSL::Digest::SHA256.new, data)
          pubkey = key.public_key
        when 'XXXX'
          # TO SOMETHING
        when 'None' || 'none' || ''
          'BlaBlaBla'
        else
          'BlaBlaBla'
        end
      rescue Exception => e
        pp e
      end
    end

    def generate_token
      @header    =  JSON.parse(@header)  unless @header.is_a?(Hash)
      @payload   =  JSON.parse(@payload) unless @payload.is_a?(Hash)
      @alg       = @header['alg']
      header    = Base64.urlsafe_encode64(@header.to_json)
      payload   = Base64.urlsafe_encode64(@payload.to_json)
      data      = "#{header}.#{payload}"
      sig       = generate_sig(data, @alg, @key)
      signature = Base64.urlsafe_encode64(sig)
      token = [header, payload, signature].join('.')
      parse(token)
      token
    end
  end
end