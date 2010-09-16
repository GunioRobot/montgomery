require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Collection' do
  before do
    mongo_connection = Mongo::Connection.new
    mongo_database = mongo_connection.db('montgomery')
    @database = Montgomery::Database.new(mongo_database)
    @mongo_collection = mongo_database.collection('items')
    @collection = Montgomery::Collection.new(mongo_collection: @mongo_collection,
                                             database: @database)
  end

  delegated_properties = [:hint, :hint=, :name, :pk_factory]
  delegated_methods = [:count, :create_index, :distinct, :drop, :drop_index,
    :drop_indexes, :group, :index_information, :map_reduce, :mapreduce,
    :options, :rename, :stats]

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

  it 'should return database' do
    @collection.database.should.equal @database
  end

  it 'should raise exception when calling #db' do
    lambda { @collection.db }.should.raise(RuntimeError)
  end

  describe 'empty' do
    it 'should return nil from #find_one' do
      @mongo_collection.expects(:find_one).with(nil, {}).returns(nil)
      @collection.find_one.should.be.nil?
    end

    it 'should return nil from #find_and_modify' do
      @mongo_collection.expects(:find_and_modify).with({}).returns(nil)
      @collection.find_and_modify.should.be.nil?
    end
  end

  describe 'with entity' do
    before do
      class User
        include Montgomery::Entity
      end

      @doc = {'name' => 'Wojciech', '_class' => 'User'}
    end

    it 'should find_one entity' do
      @mongo_collection.expects(:find_one).returns(@doc)

      entity = @collection.find_one
      entity.should.be.instance_of(User)
      entity.instance_variable_get(:@name).should.equal('Wojciech')
    end

    it 'should find_and_modify entity' do
      @mongo_collection.expects(:find_and_modify).returns(@doc)

      entity = @collection.find_and_modify
      entity.should.be.instance_of(User)
      entity.instance_variable_get(:@name).should.equal('Wojciech')
    end

    it 'should insert an entity' do
      id = BSON::ObjectId.from_time(Time.now)
      @mongo_collection.expects(:insert).with([@doc], {}).returns(id)

      user = User.new name: 'Wojciech'
      @collection.insert(user)
      user._id.should.equal id
    end

    it 'should insert 2 entities' do
      doc1 = @doc
      doc2 = {'name' => 'Hubert', '_class' => 'User'}
      id1 = BSON::ObjectId.from_time(Time.now)
      id2 = BSON::ObjectId.from_time(Time.now)
      @mongo_collection.expects(:insert).
                        with([doc1, doc2], {}).
                        returns([id1, id2])

      user1 = User.new name: 'Wojciech'
      user2 = User.new name: 'Hubert'
      @collection.insert([user1, user2])
      user1._id.should.eql id1
      user2._id.should.eql id2
    end
  end
end
