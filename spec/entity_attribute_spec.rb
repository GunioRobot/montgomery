require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class AttributeItem
  include Montgomery::Entity::Attribute
end

describe 'Montgomery::Entity' do
  it 'should define attr_reader with montgomery_attr_reader' do
    AttributeItem.montgomery_attr_reader :size
    AttributeItem.public_instance_methods.should.include(:size)
    AttributeItem.montgomery_attrs.should.include(:size)
  end

  it 'should define attr_accessor with montgomery_attr_accessor' do
    AttributeItem.montgomery_attr_accessor :weight
    AttributeItem.public_instance_methods.should.include(:weight)
    AttributeItem.public_instance_methods.should.include(:weight=)
    AttributeItem.montgomery_attrs.should.include(:weight)
  end
end
