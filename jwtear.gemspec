
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jwtear/version"

Gem::Specification.new do |spec|
  spec.name          = "jwtear"
  spec.version       = Jwtear::VERSION
  spec.authors       = ["KING SABRI"]
  spec.email         = ["king.sabri@gmail.com"]

  spec.summary       = %q{JWTear, command-line tool and library to parse, create and manipulate JWT tokens for security testing purposes.}
  spec.description   = %q{JWTear, command-line tool and library to parse, create and manipulate JWT tokens for security testing purposes.}
  spec.homepage      = "https://github.com/KINGSABRI/jwtear"
  spec.license       = "MIT"

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
