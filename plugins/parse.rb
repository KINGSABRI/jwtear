require 'time'

module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print

    desc "Parse JWT token (accepts JWS and JWE formats)."
    arg_name "JWT_TOKEN", :required
    command [:parse] do |c|
      c.desc "JWT token to parse. (Accept JWS and JWE formats)"
      c.arg_name 'JWT_TOKEN'
      c.flag [:t, :token], required: true
      c.example'jwtear parse -t eyJhb...pXUyJ.eyJsb...DgwIn.YjY4Z...DgzYThkOGJiZQ',
                desc: 'parse token'
      c.action do |_, options, _|
        # if options[:token].nil?
        #   print_error "Missing option: -t/--t"
        #   exit!
        # end
        parse = Plugin::Parse.new
        parse.token(options[:token])
      end
    end
  end

  module Plugin
    class Parse
      include JWTear::Helpers::Extensions::Print

      def initialize
        @token_ops = Token.new
      end

      def token(token)
        @token = @token_ops.parse(token)
        token_type = @token.class.to_s.split('::').last
        puts
        print_h1 token_type
        case token_type
        when "JWS" then print_jws
        when "JWE" then print_jwe
        else
          print_error "Unknown type."
        end
      end

      def print_jws
        puts @token.to_json_presentation
        puts
        print_jwt_header(@token.header)
        print_jws_payload(@token.payload)
        print_jws_sig(@token.signature)
      end

      def print_jwe
        puts @token.to_json_presentation
        puts
        print_jwt_header(@token.header)
        print_jwe_cek(@token)
        print_jwe_iv(@token)
        print_jwe_cipher_text(@token)
        print_jwe_authentication_tag(@token)
      end

      def print_jwe_cek(token)
        print_h2 "Encrypted key (CEK)"
        if token.is_encrypted?(token.encrypted_key)
          puts Base64.urlsafe_encode64(token.encrypted_key)
        else
          puts token.encrypted_key
          JSON.parse(token.encrypted_key).each do |k, v|
            puts "  - " + "#{k}: ".cyan.bold + "#{v}"
          end
        end
      end

      def print_jwt_header(header)
        print_h2 "Header"
        header.each do |k, v|
          print_h3 "#{k}" , "#{v}"
        end
      end

      def print_jws_payload(payload)
        print_h2 "Payload"
        payload.each do |k, v|
          if k == "iat" || k == "nbf"            
            print_h3 "#{k}" , "#{v}", "\tTIMESTAMP = #{Time.at(v.to_i)}".green
          elsif k == "exp" 
            compare_time_with_now(k,v)
          else
            print_h3 "#{k}" , "#{v}"
          end          
        end
      end

      def compare_time_with_now(k, timestamp)
        if timestamp.nil?
          return
        end
        readable_time = Time.at(timestamp.to_i)
        if readable_time < Time.now
          print_h3 "#{k}", "#{timestamp}", "\tTIMESTAMP = #{readable_time}\t(EXPIRED)".red
        else
          print_h3 "#{k}", "#{timestamp}", "\tTIMESTAMP = #{readable_time}".green
        end
      end
      
      def print_jws_sig(signature)
        print_h2 "Signature - B64 encoded"
        puts Base64.urlsafe_encode64(@token.signature, padding: false)
      end

      def print_jwe_iv(token)
        print_h2 "Initial vector (IV)"
        puts Base64.urlsafe_encode64(token.iv)
      end

      def print_jwe_cipher_text(token)
        print_h2 "Cipher text"
        puts Base64.urlsafe_encode64(token.cipher_text)
      end

      def print_jwe_authentication_tag(token)
        print_h2 "authentication tag"
        puts Base64.urlsafe_encode64(token.authentication_tag)
      end
    end
  end
end
