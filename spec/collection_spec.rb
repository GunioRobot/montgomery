require './spec/spec_helper'

describe Montgomery::Collection do
  it_behaves_like "delegated", :to => Mongo::Collection

  let(:mongo_connection) { Mongo::Connection.new }
  let(:mongo_database) { mongo_connection.db('montgomery') }
  let(:mongo_collection) { mongo_database.collection('items') }
  let(:database) { Montgomery::Database.new(mongo_database) }

  subject do
    Montgomery::Collection.new mongo_collection: mongo_collection,
                               database: database
  end

  it 'should return subcollection' do
    mongo_collection.should_receive(:[]).with('small')
    subject['small'].should be_instance_of(Montgomery::Collection)
  end

  it 'should return database when calling #database' do
    subject.database.should equal(database)
  end

  it 'should return database when calling #db' do
    subject.db.should equal(database)
  end

  it 'should return a Mongo::Collection' do
    subject.to_mongo.should be_instance_of Mongo::Collection
  end

  describe 'empty' do
    it 'should return nil from #find_one' do
      mongo_collection.should_receive(:find_one).with(nil, {}) { nil }
      subject.find_one.should be_nil
    end

    it 'should return nil from #find_and_modify' do
      mongo_collection.should_receive(:find_and_modify).with({}) { nil }
      subject.find_and_modify.should be_nil
    end
  end

  describe 'with entity' do
    let(:doc) do
      {'name' => 'Wojciech', '_class' => 'User'}
    end

    it 'should find_one entity' do
      mongo_collection.should_receive(:find_one) { doc }

      entity = subject.find_one
      entity.should be_instance_of(User)
      entity.name.should eql('Wojciech')
    end

    it 'should find_and_modify entity' do
      mongo_collection.should_receive(:find_and_modify) { doc }

      entity = subject.find_and_modify
      entity.should be_instance_of(User)
      entity.name.should eql('Wojciech')
    end

    it 'should insert an entity' do
      id = Factory.mongo_object_id
      doc = {:name => 'Wojciech', :_class => 'User', :weight => nil}
      mongo_collection.should_receive(:insert).with([doc], {}) { id }

      user = User.new 'name' => 'Wojciech'
      subject.insert(user).should eql([id])
      Montgomery::Silencer.silently { user._id.should eql(id) }
    end

    it 'should insert 2 entities' do
      doc1 = {:name => 'Wojciech', :_class => 'User', :weight => nil}
      doc2 = {:name => 'Hubert', :_class => 'User', :weight => nil}
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      mongo_collection.should_receive(:insert).
                        with([doc1, doc2], {}) { [id1, id2] }

      user1 = User.new 'name' => 'Wojciech'
      user2 = User.new 'name' => 'Hubert'
      subject.insert([user1, user2]).should eql([id1, id2])
      user1._id.should eql id1
      user2._id.should eql id2
    end

    it 'should remove all entities' do
      mongo_collection.should_receive(:remove).with({}, {}) { true }

      subject.remove.should eql true
    end

    it 'should remove all entities with name Wojciech' do
      mongo_collection.should_receive(:remove).
                        with({name: 'Wojciech'}, {}) { true }

      subject.remove({name: 'Wojciech'}).should be_true
    end

    it 'should remove existing entity' do
      user_id = Factory.mongo_object_id
      user = User.new({'_id' => user_id})
      mongo_collection.should_receive(:remove).
                        with({_id: {'$in' => [user_id]}}, {}) { true }
      subject.remove(user).should be_true
    end

    it 'should save the entity with id and retain the id' do
      id = Factory.mongo_object_id
      mongo_collection.should_receive(:save).with({
        :_id => id,
        :name => 'Hubert',
        :_class => 'User',
        :weight => nil
      }, {}) { id }
      user = User.new('name' => 'Wojciech', '_id' => id)
      user.name = 'Hubert'
      Montgomery::Silencer.silently { subject.save(user).should eql(id) }
    end

    it 'should save the entity without id and assign an id' do
      id = Factory.mongo_object_id
      mongo_collection.should_receive(:save).with({
        :name => 'Hubert',
        :_class => 'User',
        :weight => nil
      }, {}) { id }
      user = User.new('name' => 'Wojciech')
      user.name = 'Hubert'
      Montgomery::Silencer.silently { subject.save(user).should eql(id) }
    end

    it 'should update the collection' do
      id = Factory.mongo_object_id
      mongo_collection.should_receive(:update).
                        with({'name' => 'Hubert'},
                          {'$set' => {'name' => 'Wojciech'}}, {})

      subject.update({'name' => 'Hubert'},
                         {'$set' => {'name' => 'Wojciech'}})
    end

    it 'should find entities without a block' do
      selector = {name: 'Wojciech'}
      cursor = mock('Mongo::Cursor')
      mongo_collection.should_receive(:find).with(selector, {}) { cursor }

      subject.find(selector).should be_instance_of Montgomery::Cursor
    end

    it 'should find entities with a block' do
      selector = {name: 'Wojciech'}
      mongo_cursor = mock('Mongo::Cursor')
      mongo_collection.should_receive(:find).with(selector, {}).and_yield(mongo_cursor)

      subject.find(selector) do |cursor|
        cursor.should be_instance_of Montgomery::Cursor
      end
    end
  end
end
