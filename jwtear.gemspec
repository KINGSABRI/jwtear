lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jwtear/version"

Gem::Specification.new do |spec|
  spec.name          = "jwtear"
  spec.version       = JWTear::VERSION
  spec.authors       = ["KING SABRI"]
  spec.email         = ["king.sabri@gmail.com"]

  spec.summary       = %q{JWTear, a modular command-line tool to parse, create and manipulate JWT tokens for security testing purposes.}
  spec.description   = %q{JWTear, a modular command-line tool to parse, create and manipulate JWT tokens for security testing purposes.}
  spec.homepage      = "https://github.com/KINGSABRI/jwtear"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['jwtear']
  spec.require_paths = ["lib"]

  spec.add_dependency 'gli',          '~> 2.19', '>= 2.19.0'
  spec.add_dependency 'json-jwt',     '~> 1.11', '>= 1.11.0'
  spec.add_dependency 'jwe',          "~> 0.4.0"
  spec.add_dependency 'tty-markdown', "~> 0.6.0"
  spec.add_dependency 'tty-pager',    "~> 0.12.1"
  spec.add_dependency 'colorize',     "~> 0.8.1"

  # spec.add_development_dependency('rake', '~> 0.9.2.2')
end
