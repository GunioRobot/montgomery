require 'bundler/setup'

$LOAD_PATH.unshift 'lib'
require 'montgomery/silencer'

Montgomery::Silencer.silently {
  Bundler.require(:development)
}

# load whole montgomery after bundler loads required gems
require 'montgomery'

require 'pp'

$LOAD_PATH.unshift 'spec/entities'
require 'user'

module Factory
  def self.mongo_object_id
    BSON::ObjectId.from_time(Time.now)
  end
end
