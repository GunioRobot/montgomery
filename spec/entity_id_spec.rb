require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class IdItem
  extend Montgomery::Entity::Attribute
  include Montgomery::Entity::Id
end

describe 'Montgomery::Entity::Id' do
  it 'should define public id, _id and private id=, _id=' do
    IdItem.public_instance_methods.should include(:id)
    IdItem.public_instance_methods.should include(:_id)
    IdItem.private_instance_methods.should include(:id=)
    IdItem.private_instance_methods.should include(:_id=)
  end

  it 'should add _id to serialized attributes' do
    IdItem.montgomery_attrs.should include(:_id)
  end
end
