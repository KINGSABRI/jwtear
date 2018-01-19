module JWTear

  # Token
  class InvalidTokenError < Exception; end

  # Algorithm Errors
  class AlgorithmRequiresKeyError < TypeError; end
  class AlgorithmUnknownError < Exception; end
end