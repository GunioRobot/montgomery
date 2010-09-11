require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')
  
describe 'Montgomery::Collection' do
  before do
    @connection = Montgomery::Connection.new
  end
  
  it 'should return a database' do
    Mongo::Connection.any_instance.expects(:db).returns(Mongo::Database.new)
    database = @connection.database('montgomery')
    database.should.be.an.instance_of(Montgomery::Database)
  end
  
  it 'should raise exception when calling #db' do
    lambda { @connection.db('montgomery') }.should.raise(RuntimeError)
  end
end

