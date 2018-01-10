# External libraries
require 'gli'

# Standard libraries
require 'base64'
require 'json'
require 'digest'
require 'openssl'

# JWTear
require_relative 'jwtear/version'
require_relative 'jwtear/errors'
require_relative 'jwtear/extensions'
require_relative 'jwtear/jwt'
require_relative 'jwtear/utils'
require_relative 'jwtear/modules'


module  JWTear
  include JWTear::Utils

  String.class_eval do
    include Extensions::Core::String
  end
  # NilClass.class_eval do
  #   include Extensions::Core::NilClass
  # end
  #
  JWTModules.load_modules
end
