require './spec/spec_helper'

describe Montgomery::Database do
  it_behaves_like "delegated", :to => Mongo::DB

  let(:mongo_database) { Mongo::Connection.new.db('montgomery') }

  subject do
    Montgomery::Database.new(mongo_database)
  end

  it 'should create a collection' do
    collection = subject.create_collection('items', {})
    collection.should be_instance_of(Montgomery::Collection)
    collection.name.should eql('items')
  end

  it 'should return a collection' do
    collection = subject.collection('items', {})
    collection.should be_instance_of(Montgomery::Collection)
    collection.name.should eql('items')
  end

  it 'should return all collections' do
    collections = subject.collections
    collections.should be_instance_of(Array)
    collections.should_not be_empty
    collections.each { |c| c.should be_instance_of(Montgomery::Collection) }
  end

  it 'should return a Mongo database' do
    subject.to_mongo.should eql(mongo_database)
  end
end
