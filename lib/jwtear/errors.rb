module JWTear
  # Algorithm Errors
  class AlgorithmRequiresKeyError < TypeError; end
  class AlgorithmUnknownError < Exception; end
end