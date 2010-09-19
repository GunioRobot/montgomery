require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Connection' do
  class_methods = Mongo::Connection.public_methods
  class_methods.each do |method|
    it "should respond to class method '#{method}'" do
      Montgomery::Connection.should.respond_to method
    end
  end

  it 'should try to connect to MongoDB with .new' do
    Mongo::Connection.expects(:new)
    Montgomery::Connection.new

    Mongo::Connection.expects(:new).with('localhost', 1234, test: true)
    Montgomery::Connection.new('localhost', 1234, test: true)
  end

  it 'should try to connect to MongoDB with .from_uri' do
    Mongo::Connection.expects(:from_uri).with('mongodb://host', {})
    Montgomery::Connection.from_uri('mongodb://host')
  end

  it 'should try to connect to MongoDB with .multi' do
    nodes = [["db1.example.com", 27017], ["db2.example.com", 27017]]
    Mongo::Connection.expects(:multi).with(nodes, {})
    Montgomery::Connection.multi(nodes)
  end

  it 'should try to connect to MongoDB with .paired' do
    nodes = [["db1.example.com", 27017], ["db2.example.com", 27017]]
    Mongo::Connection.expects(:paired).with(nodes, {})
    Montgomery::Connection.paired(nodes)
  end

  describe 'when connected' do
    before do
      @mongo_connection = mock('Mongo::Connection')
      Mongo::Connection.stubs(:new).returns(@mongo_connection)

      @connection = Montgomery::Connection.new
    end

    instance_methods = Mongo::Connection.public_instance_methods
    instance_methods.each do |method|
      it "should respond to instance method '#{method}'" do
        @connection.should.respond_to method
      end
    end

    it 'should return a Mongo::Connection' do
      @connection.to_mongo.should.equal @mongo_connection
    end

    it 'should return a database from #database' do
      options = {test: true}
      @mongo_connection.expects(:db).with('montgomery', options).returns(stub)

      database = @connection.database('montgomery', options)
      database.should.be.an.instance_of(Montgomery::Database)
    end

    it 'should raise exception when calling #db' do
      lambda { @connection.db('montgomery') }.should.raise(RuntimeError)
    end

    it 'should return a database from #[]' do
      @mongo_connection.expects(:[]).returns(stub)

      database = @connection['montgomery']
      database.should.be.an.instance_of(Montgomery::Database)
    end
  end
end
