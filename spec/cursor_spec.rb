require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Cursor' do
  before do
    mongo_connection = Mongo::Connection.new
    mongo_database = mongo_connection.db('montgomery')
    mongo_collection = mongo_database.collection('items')
    @mongo_cursor = mongo_collection.find
    @cursor = Montgomery::Cursor.new(@mongo_cursor)
  end

  it 'should return all entities' do
    id1 = Factory.object_id
    id2 = Factory.object_id
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
end
