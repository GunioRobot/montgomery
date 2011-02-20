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

def current_instance_methods(klass)
  klass.public_instance_methods - klass.superclass.public_instance_methods
end

shared_examples_for "delegated" do |options|
  describe "class methods" do
    delegatee = options[:to]
    class_methods = delegatee.public_methods - delegatee.superclass.public_methods
    class_methods.each do |method|
      it "should respond to class method '#{method}'" do
        described_class.should respond_to method
      end
    end
  end

  #let(:klass) { described_class.new([7, 2, 4]) }
end
