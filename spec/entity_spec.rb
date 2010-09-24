require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class EntityItem
  include Montgomery::Entity
end

describe 'Montgomery::Entity' do
  it 'should include Attribute and Id modules to base' do
    EntityItem.included_modules.should.include(Montgomery::Entity::Attribute)
    EntityItem.included_modules.should.include(Montgomery::Entity::Id)
  end

=begin

  describe 'included into an Item' do
    before do
      @doc = {
        '_id' => Factory.mongo_object_id,
        'name' => Faker::Lorem.sentence,
        'weight' => rand(100)
      }
      @item = Item.new(@doc)
    end

    it 'should return _id' do
      @item._id.should.equal(@doc['_id'])
    end
  end
=end
end
