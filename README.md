# Jwtear
A modular Command-line tool to parse, create and manipulate JSON Web Token(JWT) tokens for security testing purposes. 

## Features
- Complete modularity.
    - All commands are plugins.
    - Easy to add a new plugins.
    - Support JWS and JWE tokens.  
- Easy interface for plugins. (follow the template example)

### Available plugins
- Parse: parses jwt tokens.
- jws: manipulate and generate JWS tokens.
- jwe: manipulate and generate JWE tokens.
- bruteforce: brutefocing JWS signing key
- wiki: contains information about JWT, attacks ideas, references.

## Installation

install it yourself as:

    $ gem install jwtear

## Usage

- Show the main menu 
```
    888888 888       888 88888888888
      "88b 888   o   888     888
       888 888  d8b  888     888
       888 888 d888b 888     888   .d88b.   8888b.  888d888
       888 888d88888b888     888  d8P  Y8b     "88b 888P"
       888 88888P Y88888     888  88888888 .d888888 888
       88P 8888P   Y8888     888  Y8b.     888  888 888
       888 888P     Y888     888   "Y8888  "Y888888 888
     .d88P                                       v1.0.0
   .d88P"
  888P"    
NAME
    jwtear - Parse, create and manipulate JWT tokens.

SYNOPSIS
    jwtear [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    -v, --version - Check current and latest version
    -h, --help    - Show this help message

COMMANDS
    help            - Shows a list of commands or help for one command
    bruteforce, bfs - plugin to offline bruteforce and crack token's signature.
    jws, s          - Generate signature-based JWT (JWS) token.
    jwe, e          - Generate encryption-based JWT (JWE) token.
    parse           - Parse JWT token (accepts JWS and JWE formats).
    wiki, w         - A JWT wiki for hackers.
```

- Show a subcommand help, use `-h COMMAND`

```
$jwtear -h jws

NAME
    jws - Generate signature-based JWT (JWS) token.

SYNOPSIS
    jwtear [global options] jws [command options] 

DESCRIPTION
    Generate JWS and JWE tokens. 

COMMAND OPTIONS
    -h, --header=JSON               - JWT header (JSON format). eg. {"typ":"JWT","alg":"HS256"}. Run 'jwtear gen -l' for supported algorithms. (required, default: none)
    -p, --payload=JSON              - JWT payload (JSON format). eg. {"login":"admin"} (required, default: none)
    -k, --key=PASSWORD|PUB_KEY_FILE - Key as a password string or a file public key. eg. P@ssw0rd  | eg. public_key.pem (default: none)
```

- Use a plugin

plugins are defined as subcommands. Each subcommand may have one or more argument and/or switches.
```
$ jwtear parse -t eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.J8SS8VKlI2yV47C4BtfYukWPx_2welF34Mz7l-MNmkE
$ jwtear jws -h '{"alg":"HS256","typ":"JWT"}' -p '{"user":"admin"}' -k p@ss0rd123
$ jwtear jwe -header '{"enc":"A192GCM","typ":"JWT"}' --payload '{"user":"admin"}' --key public.pem 
$ jwtear bruteforce -v -t eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyIjpudWxsfQ.Tr0VvdP6rVBGBGuI_luxGCOaz6BbhC6IxRTlKOW8UjM -l ~/tmp/pass.list
```

## Add plugin
To add a new plugin, create a new ruby file under `plugins` directory with the following structure
```ruby
module JWTear
  module CLI
    extend GLI::App
    extend JWTear::Helpers::Extensions::Print
    extend JWTear::Helpers::Utils

    desc "Plugin short description"
    long_desc "Plugin long description"
    command [:template, :pt] do |c|
      c.action do |global, options, arguments|
        print_h1 "Plugin template"
        print_good "Hi, I'm a template."
        template = TemplatePlugin.new
      end
    end
  end

  module Plugin
    class TemplatePlugin
      include JWTear::Helpers::Extensions::Print
      include JWTear::Helpers::Utils

      def initialize
        check_dependencies
        # ..code...
      end
     
      # ..code...
    end
  end
end
```
Instead of including all dependencies for each plugin into jwtear, you can add these dependencies as a hash to `check_dependencies` method which will require the library and throw a gentle error to the user to install any missing gems.

The hash _key_ is the gem name to install, the hash _value_ is the `require` string 
```ruby
deps = {'async-io' => 'async/ip'}
check_dependencies(deps)
```
Once the missing dependencies are installed by the user, the `check_dependencies` will require them once the plugin class initiated.



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jwtear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
