require './spec/spec_helper'

describe Montgomery::Mapper do
  it 'should create entity from doc' do
    mongo_doc = {
      '_id' => Factory.mongo_object_id,
      'name' => Faker::Lorem.sentence,
      'weight' => rand(100),
      '_class' => 'User'
    }

    entity = Montgomery::Mapper.from_doc(mongo_doc)
    entity.should be_instance_of(User)
    entity.id.should eql(mongo_doc['_id'])
    entity.name.should eql(mongo_doc['name'])
    entity.weight.should eql(mongo_doc['weight'])
  end

  it "shouldn't create entity when doc is nil" do
    Montgomery::Mapper.from_doc(nil).should be_nil
  end

  it 'should convert entity without id into Mongo doc' do
    doc = {
      :name => Faker::Lorem.sentence,
      :weight => rand(100)
    }
    entity = User.new('name' => doc[:name], 'weight' => doc[:weight])

    mongo_doc = doc.clone
    mongo_doc[:_class] = 'User'

    doc = Montgomery::Mapper.to_doc(entity)
    doc.should eql(mongo_doc)
  end

  it 'should convert entity with id into Mongo doc' do
    doc = {
      :_id => Factory.mongo_object_id,
      :name => Faker::Lorem.sentence,
      :weight => rand(100)
    }
    entity = User.new('_id' => doc[:_id],
                      'name' => doc[:name],
                      'weight' => doc[:weight])
    mongo_doc = doc.clone
    mongo_doc[:_class] = 'User'
    doc = Montgomery::Mapper.to_doc(entity)
    Montgomery::Silencer.silently { doc.should eql(mongo_doc) }
  end
end
