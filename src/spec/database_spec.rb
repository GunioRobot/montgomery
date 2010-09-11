require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Database' do
  before do
    @database = Montgomery::Database.new(Mongo::Database.new)
  end

  it 'should return a collection' do
    Mongo::Database.any_instance.expects(:collection).returns(Mongo::Collection.new)
    collection = @database.collection('items')
    collection.should.be.an.instance_of(Montgomery::Collection)
  end
end

