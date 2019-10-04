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

The main menu 
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
To see the subcommand help, use `-h COMMAND`
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jwtear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
