module  JWTear

  # Algorithms module contains all algorithms that are supported for this lib
  # @Note if you are looking for production library, please use jwt gem
  module Algorithms

    # sha generates SHA signature
    #
    # @param data [String] the data you want to encrypt or make signature for.
    # @param alg [String] the algorithm you want. @example: SHA256, SHA384, SHA512
    # @param key [String]
    # @return [String] SHA signature
    def sha(data, alg, key)
      raise AlgorithmRequiresKeyError if key.nil?
      digit = /[[:digit:]]+/
      OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'.sub(digit, alg[digit])), key, data)
    end

    # rsa generates RSA signature
    #
    # @param data [String] the data you want to encrypt or make signature for.
    # @param alg [String] the algorithm you want. @example: RSA256, RSA384, RSA512
    # @return [Hash] of public_key, private_key and signature
    def rsa(data, alg)
      rsa_private = OpenSSL::PKey::RSA.generate(2048)
      rsa_public  = @rsa_private.public_key
      signature   = @rsa_private.sign(OpenSSL::Digest.new(alg.sub('RS', 'sha')), data)

      {public_key: rsa_public, private_key: rsa_private, signature: signature}
      # FIXME: need to sign using public key
      # cert   = File.open('pub_cert.pem').read
      # @public_key = OpenSSL::PKey::RSA.new(cert)
      # raise 'Not a public certificate' unless public_key.public?
    end

    # ecdsa generates ESDSA signature
    # @param data [String]
    # @param alg [String]
    # @return [String] of ESDSA signature
    def ecdsa(data, alg)
      # TODO:
      #   - fixme
      #   - support P-256 as SHA256
      ecdsa_key = OpenSSL::PKey::EC.new('prime256v1')
      ecdsa_key.generate_key
      ecdsa_public = OpenSSL::PKey::EC.new(ecdsa_key)
      ecdsa_public.private_key = nil
    end

    # @return [String] empty string if none algorithm, yes it happens in JWT
    def none
      ''
    end

    # just a soft message for unsupported algorithms
    def unsupported_algorithm(alg)
      "Unsupported Algorithm: #{alg}"
    end

  end
end