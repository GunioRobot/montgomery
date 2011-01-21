module Montgomery
  module Silencer
    def self.silently(&block)
      warn_level = $VERBOSE
      $VERBOSE = nil
      result = block.call
      $VERBOSE = warn_level
      result
    end
  end
end
