gem 'test-unit'
require 'test/spec'
require 'mocha'

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

