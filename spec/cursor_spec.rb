require './spec/spec_helper'

describe Montgomery::Cursor do
  it 'should include Enumerable' do
    Montgomery::Cursor.should include Enumerable
  end

  describe 'new instance' do
    it_behaves_like "delegated", :to => Mongo::Cursor

    let(:mongo_connection) { Mongo::Connection.new }
    let(:mongo_database) { mongo_connection.db('montgomery') }
    let(:mongo_collection) { mongo_database.collection('items') }
    let(:mongo_cursor) { mongo_collection.find }
    let(:database) { Montgomery::Database.new(mongo_database) }
    let(:collection) do
      Montgomery::Collection.new mongo_collection: mongo_collection,
                                 database: database
    end

    subject do
      Montgomery::Cursor.new mongo_cursor: mongo_cursor,
                             collection: collection
    end

    it 'should return collection' do
      subject.collection.should equal collection
    end

    it 'should return a Mongo::Cursor' do
      subject.to_mongo.should be_instance_of Mongo::Cursor
    end

    it 'should return all entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      mongo_cursor.should_receive(:to_a) {
        [
          {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
          {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
        ]
      }

      users = subject.to_a
      users[0].name.should eql 'Hubert'
      users[0]._id.should eql id1
      users[1].name.should eql 'Wojciech'
      users[1]._id.should eql id2
    end

    it 'should return next entity on #next_document' do
      doc = {
        '_id' => Factory.mongo_object_id,
        'name' => 'Wojciech',
        '_class' => 'User'
      }
      mongo_cursor.should_receive(:next_document) { doc }

      subject.next_document.should be_instance_of User
    end

    it 'should return next entity' do
      doc = {
        '_id' => Factory.mongo_object_id,
        'name' => 'Wojciech',
        '_class' => 'User'
      }
      mongo_cursor.should_receive(:next_document) { doc }

      subject.next_entity.should be_instance_of User
    end

    it 'should iterate over the entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      docs = [
        {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
        {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
      ]
      mongo_cursor.should_receive(:each).and_yield(docs[0]).and_yield(docs[1])

      index = 0
      subject.each do |entity|
        entity.should be_instance_of User
        entity.name.should eql docs[index]['name']
        entity._id.should eql docs[index]['_id']

        index += 1
      end
    end
  end
end
