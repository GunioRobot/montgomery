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

Mongo::Connection.new.drop_database('montgomery')

module Factory
  def self.mongo_object_id
    BSON::ObjectId.from_time(Time.now)
  end
end

shared_examples_for "delegated" do |options|
  delegatee = options[:to]

  class_methods = delegatee.public_methods -
                  delegatee.superclass.public_methods
  class_methods.each do |method|
    it "should respond to class method '#{method}'" do
      described_class.should respond_to method
    end
  end

  instance_methods = delegatee.public_instance_methods -
                     delegatee.superclass.public_instance_methods
  instance_methods.each do |method|
    it "should respond to instance method '#{method}'" do
      subject.should respond_to method
    end
  end
end
