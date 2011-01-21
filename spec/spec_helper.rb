$LOAD_PATH.unshift 'lib'
require 'montgomery'

require 'bundler/setup'

Montgomery::Silencer.silently {
  Bundler.require(:test)
}

require 'pp'

$LOAD_PATH.unshift 'spec/entities'
require 'user'

module Factory
  def self.mongo_object_id
    BSON::ObjectId.from_time(Time.now)
  end
end
