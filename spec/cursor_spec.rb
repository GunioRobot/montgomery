require './spec/spec_helper'

describe 'Montgomery::Cursor' do
  describe 'class methods' do
    current_class_methods(Mongo::Cursor).each do |method|
      it "should respond to class method '#{method}'" do
        Montgomery::Cursor.should respond_to(method)
      end
    end
  end

  it 'should include Enumerable' do
    Montgomery::Cursor.should include Enumerable
  end

  describe 'new instance' do
    before do
      mongo_connection = Mongo::Connection.new
      mongo_database = mongo_connection.db('montgomery')
      mongo_collection = mongo_database.collection('items')
      @mongo_cursor = mongo_collection.find

      database = Montgomery::Database.new(mongo_database)
      @collection = Montgomery::Collection.new mongo_collection: mongo_collection,
                                               database: database
      @cursor = Montgomery::Cursor.new mongo_cursor: @mongo_cursor,
                                       collection: @collection
    end

    current_instance_methods(Mongo::Cursor).each do |method|
      it "should respond to instance method '#{method}'" do
        @cursor.should respond_to(method)
      end
    end

    it 'should return collection' do
      @cursor.collection.should equal @collection
    end

    it 'should return a Mongo::Cursor' do
      @cursor.to_mongo.should be_instance_of Mongo::Cursor
    end

    it 'should return all entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      @mongo_cursor.should_receive(:to_a) {
        [
          {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
          {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
        ]
      }

      users = @cursor.to_a
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
      @mongo_cursor.should_receive(:next_document) { doc }

      @cursor.next_document.should be_instance_of User
    end

    it 'should return next entity' do
      doc = {
        '_id' => Factory.mongo_object_id,
        'name' => 'Wojciech',
        '_class' => 'User'
      }
      @mongo_cursor.should_receive(:next_document) { doc }

      @cursor.next_entity.should be_instance_of User
    end

    it 'should iterate over the entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      docs = [
        {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
        {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
      ]
      @mongo_cursor.should_receive(:each).and_yield(docs[0]).and_yield(docs[1])

      index = 0
      @cursor.each do |entity|
        entity.should be_instance_of User
        entity.name.should eql docs[index]['name']
        entity._id.should eql docs[index]['_id']

        index += 1
      end
    end
  end
end
