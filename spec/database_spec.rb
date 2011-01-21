require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Database' do
  describe 'class methods' do
    class_methods = Mongo::DB.public_methods
    # for some reason this method isn't delegated, but it isn't very useful anyway
    class_methods.delete :yaml_tag_subclasses?
    class_methods.each do |method|
      it "should respond to class method '#{method}'" do
        Montgomery::Database.should respond_to method
      end
    end
  end

  before do
    @mongo_database = Mongo::Connection.new.db('montgomery')
    @database = Montgomery::Database.new(@mongo_database)
  end

  instance_methods = Mongo::DB.public_instance_methods
  instance_methods.each do |method|
    it "should respond to instance method '#{method}'" do
      @database.should respond_to method
    end
  end

  it 'should create a collection' do
    collection = @database.create_collection('items', {})
    collection.should be_instance_of(Montgomery::Collection)
    collection.name.should eql('items')
  end

  it 'should return a collection' do
    collection = @database.collection('items', {})
    collection.should be_instance_of(Montgomery::Collection)
    collection.name.should eql('items')
  end

  it 'should return all collections' do
    collections = @database.collections
    collections.should be_instance_of(Array)
    collections.should_not be_empty
    collections.each { |c| c.should be_instance_of(Montgomery::Collection) }
  end

  it 'should return a Mongo database' do
    @database.to_mongo.should equal @mongo_database
  end
end
