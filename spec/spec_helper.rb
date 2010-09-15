def silently(&block)
  warn_level = $VERBOSE
  $VERBOSE = nil
  result = block.call
  $VERBOSE = warn_level
  result
end

gem 'test-unit'
require 'test/spec'
silently { require 'mocha' }

require 'pp'

$LOAD_PATH.unshift 'lib'
require 'montgomery'

module Mongo
  class Connection
    def initialize
      super
    end
  end
  
  class Database
  end

  class Collection
  end
end

