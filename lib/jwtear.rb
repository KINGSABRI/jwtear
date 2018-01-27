# Standard libraries
require 'base64'
require 'json'
require 'digest'
require 'openssl'
require 'open-uri'

# JWTear
require_relative 'jwtear/version'
require_relative 'jwtear/errors'
require_relative 'jwtear/extensions'
require_relative 'jwtear/jwt'
require_relative 'jwtear/utils'


module  JWTear
  include JWTear::Utils

  String.class_eval do
    include Extensions::Core::String
  end
  # NilClass.class_eval do
  #   include Extensions::Core::NilClass
  # end
end
