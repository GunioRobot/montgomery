require './spec/spec_helper'

describe 'Montgomery::Connection' do
  describe "not connected" do
    current_class_methods(Mongo::Connection).each do |method|
      it "should respond to class method '#{method}'" do
        Montgomery::Connection.should respond_to method
      end
    end

    it 'should try to connect to MongoDB with .new without args' do
      Mongo::Connection.should_receive(:new)
      Montgomery::Connection.new
    end

    it 'should try to connect to MongoDB with .new with args' do
      args = ['localhost', 27017, {}]
      Mongo::Connection.should_receive(:new).with(*args)
      Montgomery::Connection.new(*args)
    end

    it 'should try to connect to MongoDB with .from_uri' do
      uri = 'mongodb://host'
      Mongo::Connection.should respond_to(:from_uri)
      Mongo::Connection.should_receive(:from_uri).with(uri, {})
      Montgomery::Connection.from_uri(uri).should be_instance_of(Montgomery::Connection)
    end

    it 'should try to connect to MongoDB with .multi' do
      nodes = [["db1.example.com", 27017], ["db2.example.com", 27017]]
      Mongo::Connection.should respond_to(:multi)
      Mongo::Connection.should_receive(:multi).with(nodes, {})
      Montgomery::Connection.multi(nodes).should be_instance_of(Montgomery::Connection)
    end
  end

  describe 'when connected' do
    before do
      @connection = Montgomery::Connection.new
    end

    current_instance_methods(Mongo::Connection).each do |method|
      it "should respond to instance method '#{method}'" do
        @connection.should respond_to method
      end
    end

    it 'should return a Mongo::Connection' do
      @connection.to_mongo.should be_instance_of(Mongo::Connection)
    end

    it 'should return a database from #database' do
      database = @connection.database('montgomery', {})
      database.should be_instance_of(Montgomery::Database)
      database.name.should eql('montgomery')
    end

    it 'should return a database from #db' do
      database = @connection.db('montgomery', {})
      database.should be_instance_of(Montgomery::Database)
      database.name.should eql('montgomery')
    end

    it 'should return a database from #[]' do
      database = @connection['montgomery']
      database.should be_instance_of(Montgomery::Database)
      database.name.should eql('montgomery')
    end
  end
end
