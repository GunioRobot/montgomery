require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Connection' do
  it 'should try to connect to MongoDB' do
    Mongo::Connection.expects(:new)
    Montgomery::Connection.new
  end

  describe 'when connected' do
    before do
      @connection = Montgomery::Connection.new
    end

    it 'should return a database' do
      database = @connection.database('montgomery')
      database.should.be.an.instance_of(Montgomery::Database)
    end

    it 'should raise exception when calling #db' do
      lambda { @connection.db('montgomery') }.should.raise(RuntimeError)
    end
  end
end
