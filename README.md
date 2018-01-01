# Jwtear
Command-line tool and library to parse, create and manipulate JWT tokens for security testing purposes. 

During working on exploiting some JWT-based application I needed some tool to make parsing and manipulating JWT token easier. 

## Installation

install it yourself as:

    $ gem install jwtear

## Usage

```
$> jwtear -h 

  888888 888       888 88888888888
    "88b 888   o   888     888
     888 888  d8b  888     888
     888 888 d888b 888     888   .d88b.   8888b.  888d888
     888 888d88888b888     888  d8P  Y8b     "88b 888P"
     888 88888P Y88888     888  88888888 .d888888 888
     88P 8888P   Y8888     888  Y8b.     888  888 888
     888 888P     Y888     888   "Y8888  "Y888888 888
   .d88P                                       v0.1.0
 .d88P"
888P"    
JWTear - Parse, create and manipulate JWT tokens.

Help menu:
   -p, --parse JWT_TOKEN            Parse JWT token
       --generate-token             Generate JWT token.
       --generate-sig               Generate JWT signature.
       --header HEADER              JWT header (JSON format). (required for generate-token and generate-sig)
                                      eg. {"typ":"JWT","alg":"HS256"}
       --payload PAYLOAD            JWT payload (JSON format). (required for generate-token and generate-sig)
                                      eg. {"login":"admin"}
       --alg ALGORITHM              Algorithm name. (required for generate-token and generate-sig)
                                      Supported algorithms: [HS256, RS512, etc]
       --key SECRET                 Secret Key for symmetric encryption. (required for generate-token and generate-sig)
                                      eg. P@ssw0rd
   -h, --help                       Show this help message

Usage:
  ruby jwtear.rb <OPTIONS>

Example:
jwtear --generate-token --header '{"typ":"JWT","alg":"HS256"}' --payload '{"login":"admin"}' --alg HS256 --key 'P@ssw0rd!'
jwtear --generate-sig  --header '{"typ":"JWT","alg":"HS256"}' --payload '{"login":"admin"}' --alg HS256 --key 'P@ssw0rd!'
jwtear --parse 'eyJI...6IJ9.kxMS...MjAMm.zEyN...TU2Njk3ZmE3OA'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jwtear.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
