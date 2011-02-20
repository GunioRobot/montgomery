$LOAD_PATH.unshift 'lib'
require 'montgomery/silencer'

Montgomery::Silencer.silently {
  require 'bundler/setup'
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

def current_class_methods(klass)
  klass.public_methods - klass.superclass.public_methods
end

def current_instance_methods(klass)
  klass.public_instance_methods - klass.superclass.public_instance_methods
end
