require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

class MapperItem
  include Montgomery::Entity

  montgomery_attr_accessor :name, :weight
end

describe 'Montgomery::Mapper' do
  it 'should create entity from doc' do
    expected_doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100)
    }

    mongo_doc = expected_doc.clone
    mongo_doc['_class'] = 'MapperItem'

    item_mock = mock
    item_mock.should_receive(:_id=).with(mongo_doc['_id'])
    MapperItem.should_receive(:new).with(expected_doc) { item_mock }

    Montgomery::Mapper.from_doc(mongo_doc)
  end

  it 'should set id to entity from doc' do
    mongo_doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100),
      '_class' => 'MapperItem'
    }

    entity = Montgomery::Mapper.from_doc(mongo_doc)
    entity.id.should eql(mongo_doc['_id'])
  end

  it "shouldn't create entity when doc is nil" do
    Montgomery::Mapper.from_doc(nil).should be_nil
  end

  it 'should convert entity without id into Mongo doc' do
    doc = {
      :name => Faker::Lorem.sentence,
      :weight => rand(100)
    }
    entity = MapperItem.new
    entity.name = doc[:name]
    entity.weight = doc[:weight]

    mongo_doc = doc.clone
    mongo_doc[:_class] = 'MapperItem'

    doc = Montgomery::Mapper.to_doc(entity)
    doc.should eql(mongo_doc)
  end

  it 'should convert entity with id into Mongo doc' do
    doc = {
      :_id => Factory.mongo_object_id,
      :name => Faker::Lorem.sentence,
      :weight => rand(100)
    }
    entity = MapperItem.new
    entity.send(:_id=, doc[:_id])
    entity.name = doc[:name]
    entity.weight = doc[:weight]

    mongo_doc = doc.clone
    mongo_doc[:_class] = 'MapperItem'

    doc = Montgomery::Mapper.to_doc(entity)
    doc.should eql(mongo_doc)
  end
end
