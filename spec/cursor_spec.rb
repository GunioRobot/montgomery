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

  it 'should return collection' do
    @cursor.collection.should.equal @collection
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
