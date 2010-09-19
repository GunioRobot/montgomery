require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Database' do
  before do
    @mongo_database = mock('Mongo::Database')
    @database = Montgomery::Database.new(@mongo_database)
  end

  it 'should return a collection' do
    @mongo_database.expects(:collection).with('items').returns(stub(name: 'items'))

    collection = @database.collection('items')
    collection.should.be.an.instance_of(Montgomery::Collection)
    collection.name.should.equal('items')
  end

  it 'should return a Mongo::Database' do
    @database.to_mongo.should.equal @mongo_database
  end
end
