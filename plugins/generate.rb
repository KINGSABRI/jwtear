module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print
    extend JWTear::Helpers::Utils
    #
    # JWS command
    #
    desc "Generate signature-based JWT (JWS) token."
    command [:jws, :s] do |jws_cmd|
      # Header
      jws_cmd.desc %Q(JWT header (JSON format). eg. {"typ":"JWT","alg":"HS256"}. Run 'jwtear gen -l' for supported algorithms.)
      jws_cmd.arg_name 'JSON'
      jws_cmd.flag [:h, :header], required: true
      # Payload
      jws_cmd.desc 'JWT payload (JSON format). eg. {"login":"admin"}'
      jws_cmd.arg_name 'JSON'
      jws_cmd.flag [:p, :payload], required: true
      # Password or public key file
      jws_cmd.desc "Key as a password string or a file public key. eg. P@ssw0rd  | eg. public_key.pem"
      jws_cmd.arg_name 'PASSWORD|PUB_KEY_FILE'
      jws_cmd.flag [:k, :key]
      jws_cmd.action do |_, options, _|
        gen = Generate.new
        puts gen.jws_token(options[:header], options[:payload], read_key(options[:key]))
      end
    end

    #
    # JWE command
    #
    desc "Generate encryption-based JWT (JWE) token."
    command [:jwe, :e] do |jwe_cmd|
      jwe_cmd.desc %Q(JWT header (JSON format). eg. {"alg"=>"RSA-OAEP", "enc"=>"A192GCM"})
      jwe_cmd.arg_name 'JSON'
      jwe_cmd.flag [:h, :header]#, required: true
      # Payload
      jwe_cmd.desc 'JWT payload (JSON format). eg. {"login":"admin"}'
      jwe_cmd.arg_name 'JSON'
      jwe_cmd.flag [:p, :payload], required: true
      # Password or public key file
      jwe_cmd.desc "Key as a password string or a file public key. eg. P@ssw0rd  | eg. public_key.pem"
      jwe_cmd.arg_name 'PASSWORD|PUB_KEY_FILE'
      jwe_cmd.flag [:k, :key]
      jwe_cmd.action do |_, options, _|
        gen = Generate.new
        puts gen.jwe_token(options[:header], options[:payload], read_key(options[:key]))
      end
    end
  end

  class Generate
    include JWTear::Helpers::Extensions::Print

    def initialize
      @token_ops = Token.new
    end

    def jws_token(header, payload, key=nil)
      @token_ops.generate(:jws, header: header, payload:payload , key: key)
    end

    def jwe_token(header, payload, key=nil)
      @token_ops.generate(:jwe, header: header, payload:payload , key: key)
    end
  end
end

