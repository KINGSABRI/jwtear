# Standard libraries
require 'base64'
require 'json'
require 'digest'
require 'openssl'

# JWTear
require_relative 'jwtear/version'
require_relative 'jwtear/utils'
require_relative 'jwtear/error'
require_relative 'jwtear/jwt'

# $LOAD_PATH << '../modules'
# require_relative '../'