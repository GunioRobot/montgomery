require './spec/spec_helper'

class IdItem
  include Montgomery::Entity::Id
end

describe Montgomery::Entity::Id do
  it 'should define public id, _id and protected _id=' do
    IdItem.public_instance_methods.should include(:id)
    IdItem.public_instance_methods.should include(:_id)
    IdItem.protected_instance_methods.should include(:_id=)
  end

  it 'should add _id to serialized attributes' do
    IdItem.montgomery_attrs.should include(:_id)
  end
end
