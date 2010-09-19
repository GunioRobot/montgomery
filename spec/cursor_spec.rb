require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Cursor' do
  class_methods = Mongo::Cursor.public_methods
  class_methods.each do |method|
    it "should respond to class method '#{method}'" do
      Montgomery::Cursor.should.respond_to(method)
    end
  end

  it 'should include Enumerable' do
    Montgomery::Cursor.should.include Enumerable
  end

  describe 'new instance' do
    before do
      mongo_connection = Mongo::Connection.new
      mongo_database = mongo_connection.db('montgomery')
      mongo_collection = mongo_database.collection('items')
      @mongo_cursor = mongo_collection.find

      database = Montgomery::Database.new(mongo_database)

      collection_values = {
        mongo_collection: mongo_collection,
        database: database
      }
      @collection = Montgomery::Collection.new(collection_values)

      cursor_values = {
        mongo_cursor: @mongo_cursor,
        collection: @collection
      }
      @cursor = Montgomery::Cursor.new(cursor_values)
    end

    instance_methods = Mongo::Cursor.public_instance_methods - Mongo::Conversions.public_instance_methods
    instance_methods.each do |method|
      it "should respond to instance method '#{method}'" do
        @cursor.should.respond_to(method)
      end
    end

    it 'should return collection' do
      @cursor.collection.should.equal @collection
    end

    it 'should return a Mongo::Cursor' do
      @cursor.to_mongo.should.be.instance_of Mongo::Cursor
    end

    it 'should return all entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      @mongo_cursor.expects(:to_a).returns([
        {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
        {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
      ])

      users = @cursor.to_a
      users[0].name.should.equal 'Hubert'
      users[0]._id.should.equal id1
      users[1].name.should.equal 'Wojciech'
      users[1]._id.should.equal id2
    end

    it 'should raise exception on #next_document' do
      lambda { @cursor.next_document }.should.raise(RuntimeError)
    end

    it 'should return next entity' do
      doc = {
        '_id' => Factory.mongo_object_id,
        'name' => 'Wojciech',
        '_class' => 'User'
      }
      @mongo_cursor.expects(:next_document).returns(doc)

      @cursor.next_entity.should.be.instance_of User
    end

    it 'should iterate over the entities' do
      id1 = Factory.mongo_object_id
      id2 = Factory.mongo_object_id
      docs = [
        {'_id' => id1, 'name' => 'Hubert', '_class' => 'User'},
        {'_id' => id2, 'name' => 'Wojciech', '_class' => 'User'}
      ]
      @mongo_cursor.expects(:each).yields(*docs)

      index = 0
      @cursor.each do |entity|
        entity.should.be.instance_of User
        entity.name.should.equal docs[index]['name']
        entity._id.should.equal docs[index]['_id']

        index += 1
      end
    end
  end
end
