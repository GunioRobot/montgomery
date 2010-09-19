require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Database' do
  before do
    mongo_connection = Mongo::Connection.new
    mongo_database = mongo_connection.db('montgomery')
    @database = Montgomery::Database.new(mongo_database)
  end

  it 'should return a collection' do
    collection = @database.collection('items')
    collection.should.be.an.instance_of(Montgomery::Collection)
    collection.name.should.equal('items')
  end

  it 'should return a Mongo::Database' do
    @database.to_mongo.should.be.instance_of Mongo::DB
  end
end
