$LOAD_PATH.unshift 'lib'
require 'montgomery'

gem 'test-unit'
require 'test/spec'
Montgomery::Silencer.silently {
  require 'mocha'
  require 'faker'
}

require 'pp'

$LOAD_PATH.unshift 'spec/entities'
require 'user'

module Factory
  def self.mongo_object_id
    BSON::ObjectId.from_time(Time.now)
  end
end
