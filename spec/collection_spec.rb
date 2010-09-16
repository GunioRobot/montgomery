require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Collection' do
  before do
    mongo_connection = Mongo::Connection.new
    mongo_database = mongo_connection.db('montgomery')
    @mongo_collection = mongo_database.collection('items')
    @collection = Montgomery::Collection.new(@mongo_collection)
  end

  delegated_properties = [:hint, :hint=, :name, :pk_factory]
  delegated_methods = [:count, :create_index, :distinct, :drop, :drop_index,
    :drop_indexes, :group, :index_information, :map_reduce, :options, :rename,
    :stats]

  (delegated_properties + delegated_methods).each do |message|
    it "should delegate #{message} to Mongo::Collection" do
      @mongo_collection.expects(message)
      @collection.send(message)

      @mongo_collection.expects(message).with(:args)
      @collection.send(message, :args)
    end
  end

  it 'should return subcollection' do
    @mongo_collection.expects(:[]).with('montgomerish')
    @collection['montgomerish'].should.be.an.instance_of(Montgomery::Collection)
  end
end
