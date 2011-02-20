require './spec/spec_helper'

class AttributeItem
  extend Montgomery::Entity::Attribute
end

describe Montgomery::Entity::Attribute do
  it 'should define attr_reader with montgomery_attr_reader' do
    AttributeItem.montgomery_attr_reader :size
    AttributeItem.public_instance_methods.should include(:size)
    AttributeItem.montgomery_attrs.should include(:size)
  end

  it 'should define attr_accessor with montgomery_attr_accessor' do
    AttributeItem.montgomery_attr_accessor :height
    AttributeItem.public_instance_methods.should include(:height)
    AttributeItem.public_instance_methods.should include(:height=)
    AttributeItem.montgomery_attrs.should include(:height)
  end
end
