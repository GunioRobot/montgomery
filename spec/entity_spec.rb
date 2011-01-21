require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class EntityItem
  include Montgomery::Entity
end

describe 'Montgomery::Entity' do
  it 'should include Attribute and Id modules to base' do
    EntityItem.included_modules.should include(Montgomery::Entity::Attribute)
    EntityItem.included_modules.should include(Montgomery::Entity::Id)
  end
end
