module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print

    desc  %Q{plugin to offline bruteforce and crack token's signature.}
    command [:bruteforce, :bfs] do |c|
      c.desc 'Token to crack its key.'
      c.arg_name 'JWT_TOKEN'
      c.flag [:t, :token], required: true

      c.desc 'Password or password list to bruteforce the signature'
      c.arg_name 'PASS_LIST'
      c.flag [:l, :p, :list, :password], required: true

      c.desc "Run verbosely."
      c.switch [:v, :verbose], negatable: false

      c.example  %Q{jwtear bruteforce -t TOKEN -l rockyou.list -v}
      c.example  %Q{jwtear bruteforce -t TOKEN -l P@ssw0rd123}

      c.action do |_, options, _|
        begin
          bf = Bruteforce.new(options[:token], options[:list])
          bf.run(options[:verbose])
        end
      end

    end
  end

  class Bruteforce
    include JWTear::Helpers::Extensions::Print
    include JWTear::Helpers::Utils

    def initialize(token, list)
      deps = {'async-io' => 'async/io'}
      check_dependencies(deps)
      @token = Token.new
      @jws   = @token.parse(token)
      @list  = list
    end

    def run(verbose=false)
      keys = handle_key
      case
      when keys.kind_of?(Enumerator::Lazy)
        keys.each do |key|
          key.valid_encoding? ? key.strip! : next
          print_status "Trying password: #{key}" if verbose

          gen_token = @token.generate(:jws, header: @jws.header.to_json, payload:@jws.payload.to_json , key: key)
          sig = gen_token.split('.').last
          if sig == Base64.urlsafe_encode64(@jws.signature, padding: false)
            print_good "Password found: #{key}"
            puts gen_token
            exit!
          else
            print_bad "Invalid key: #{key}" if verbose
          end
        end
      when keys.kind_of?(String)
        gen_token = @token.generate(:jws, header: @jws.header.to_json, payload:@jws.payload.to_json , key: keys)
        sig = gen_token.split('.').last
        if sig == Base64.urlsafe_encode64(@jws.signature, padding: false)
          print_good "Password found: #{keys}"
          puts gen_token
        else
          print_bad "Invalid key: #{keys}"
        end

      else
        print_error "Unknown key type"
        raise
      end
    end


    def handle_key
      if File.file?(@list)
        read_wordlist(@list)
      else
        @list
      end
    end

    def read_wordlist(file)
      if File.file?(file)
        print_status "Found '#{file}' file."
        File.readlines(file, chomp: true)
            .lazy
            .reject(&:empty?)
            .reject(&:nil?)
      else
        print_bad "File not found. #{file}"
        exit!
      end
    end

  end
end

