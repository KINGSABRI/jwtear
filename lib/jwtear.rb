# Standard libraries
require 'base64'
require 'json'
require 'digest'
require 'openssl'

# JWTear
require_relative 'jwtear/version'
require_relative 'jwtear/error'
require_relative 'jwtear/extensions'
# require_relative 'jwtear/utils'
require_relative 'jwtear/jwt'


module  JWTear
  String.class_eval do
    include Extensions::Core::String
  end
  # NilClass.class_eval do
  #   include Extensions::Core::NilClass
  # end
end


# $LOAD_PATH << '../modules'
# require_relative '../'