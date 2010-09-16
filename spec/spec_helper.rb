$LOAD_PATH.unshift 'lib'
require 'montgomery'

gem 'test-unit'
require 'test/spec'
Montgomery::Silencer.silently { require 'mocha' }

require 'pp'
