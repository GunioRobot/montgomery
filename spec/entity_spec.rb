require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class Item
  include Montgomery::Entity
end

describe 'Montgomery::Entity' do
  it 'should set @_id to nil on initialize when doc is empty' do
    Item.new.instance_variable_defined?(:@_id).should.equal(true)
    Item.new.instance_variable_get(:@_id).should.equal(nil)
  end

  it 'should set instance variables from passed doc on initialize' do
    doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100)
    }

    item = Item.new(doc)
    item.instance_variable_get(:@name).should.equal(doc['name'])
    item.instance_variable_get(:@weight).should.equal(doc['weight'])
    item.instance_variable_get(:@_id).should.equal(doc['_id'])
  end

  it 'should create entity from doc' do
    doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100),
      '_class' => 'Item'
    }

    expected_doc = doc.clone
    expected_doc.delete('_class')

    Item.expects(:new).with(expected_doc)

    Montgomery::Mapper.from_doc(doc)
  end

  it "shouldn't create entity when doc is nil" do
    Montgomery::Mapper.from_doc(nil).should.equal(nil)
  end

  it 'should convert entity without _id into Mongo doc' do
    doc = {
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100)
    }
    entity = Item.new(doc)

    expected_doc = doc.clone
    expected_doc['_class'] = 'Item'

    doc = Montgomery::Mapper.to_doc(entity)
    doc.should.equal(expected_doc)
  end

  it 'should convert entity with _id into Mongo doc' do
    doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100)
    }
    entity = Item.new(doc)

    expected_doc = doc.clone
    expected_doc['_class'] = 'Item'

    doc = Montgomery::Mapper.to_doc(entity)
    doc.should.equal(expected_doc)
  end

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
end
