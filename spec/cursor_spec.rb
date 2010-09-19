require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Cursor' do
  before do
    mongo_connection = Mongo::Connection.new
    mongo_database = mongo_connection.db('montgomery')
    database = Montgomery::Database.new(mongo_database)
    mongo_collection = mongo_database.collection('items')
    @collection = Montgomery::Collection.new(mongo_collection: mongo_collection,
      database: database)
    @mongo_cursor = mongo_collection.find
    values = {mongo_cursor: @mongo_cursor, collection: @collection}
    @cursor = Montgomery::Cursor.new(values)
  end

  it 'should include Enumerable' do
    Montgomery::Cursor.should.include Enumerable
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

  it 'should return collection' do
    @cursor.collection.should.equal @collection
  end

  it 'should return a Mongo::Cursor' do
    @cursor.to_mongo.should.be.instance_of Mongo::Cursor
  end

  delegated_properties = [:batch_size, :fields, :full_collection_name, :hint,
    :order, :selector, :snapshot, :timeout]
  delegated_methods = [:close, :closed?, :count, :explain, :has_next?, :inspect,
    :limit, :query_options_hash, :query_opts, :rewind!, :skip, :sort]

  (delegated_properties + delegated_methods).each do |message|
    it "should delegate #{message} to Mongo::Cursor" do
      @mongo_cursor.expects(message)
      @cursor.send(message)

      @mongo_cursor.expects(message).with(:args)
      @cursor.send(message, :args)
    end
  end
end
