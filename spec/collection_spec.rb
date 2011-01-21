require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Collection' do
  describe 'class methods' do
    class_methods = Mongo::Collection.public_methods
    # for some reason this method isn't delegated, but it isn't very useful anyway
    class_methods.delete :yaml_tag_subclasses?
    class_methods.each do |method|
      it "should respond to class method '#{method}'" do
        Montgomery::Collection.should respond_to method
      end
    end
  end

  describe 'new instance' do
    before do
      mongo_connection = Mongo::Connection.new
      mongo_database = mongo_connection.db('montgomery')
      @mongo_collection = mongo_database.collection('items')

      @database = Montgomery::Database.new(mongo_database)
      @collection = Montgomery::Collection.new mongo_collection: @mongo_collection,
                                               database: @database
    end

    instance_methods = Mongo::Collection.public_instance_methods
    instance_methods.each do |method|
      it "should respond to instance method '#{method}'" do
        @collection.should respond_to method
      end
    end

    it 'should return subcollection' do
      @mongo_collection.should_receive(:[]).with('small')
      @collection['small'].should be_instance_of(Montgomery::Collection)
    end

    it 'should return database when calling #database' do
      @collection.database.should equal(@database)
    end

    it 'should return database when calling #db' do
      @collection.db.should equal(@database)
    end

    it 'should return a Mongo::Collection' do
      @collection.to_mongo.should be_instance_of Mongo::Collection
    end

    describe 'empty' do
      it 'should return nil from #find_one' do
        @mongo_collection.should_receive(:find_one).with(nil, {}) { nil }
        @collection.find_one.should be_nil
      end

      it 'should return nil from #find_and_modify' do
        @mongo_collection.should_receive(:find_and_modify).with({}) { nil }
        @collection.find_and_modify.should be_nil
      end
    end

    describe 'with entity' do
      before do
        @doc = {'name' => 'Wojciech', '_class' => 'User'}
      end

      it 'should find_one entity' do
        @mongo_collection.should_receive(:find_one) { @doc }

        entity = @collection.find_one
        entity.should be_instance_of(User)
        entity.name.should eql('Wojciech')
      end

      it 'should find_and_modify entity' do
        @mongo_collection.should_receive(:find_and_modify) { @doc }

        entity = @collection.find_and_modify
        entity.should be_instance_of(User)
        entity.name.should eql('Wojciech')
      end

      it 'should insert an entity' do
        id = Factory.mongo_object_id
        doc = {:name => 'Wojciech', :_class => 'User'}
        @mongo_collection.should_receive(:insert).with([doc], {}) { id }

        user = User.new 'name' => 'Wojciech'
        @collection.insert(user).should eql [id]
        user._id.should eql id
      end

      it 'should insert 2 entities' do
        doc1 = {:name => 'Wojciech', :_class => 'User'}
        doc2 = {:name => 'Hubert', :_class => 'User'}
        id1 = Factory.mongo_object_id
        id2 = Factory.mongo_object_id
        @mongo_collection.should_receive(:insert).
                          with([doc1, doc2], {}) { [id1, id2] }

        user1 = User.new 'name' => 'Wojciech'
        user2 = User.new 'name' => 'Hubert'
        @collection.insert([user1, user2]).should eql [id1, id2]
        user1._id.should eql id1
        user2._id.should eql id2
      end

      it 'should remove all entities' do
        @mongo_collection.should_receive(:remove).with({}, {}) { true }

        @collection.remove.should eql true
      end

      it 'should remove all entities with name Wojciech' do
        @mongo_collection.should_receive(:remove).
                          with({name: 'Wojciech'}, {}) { true }

        @collection.remove({name: 'Wojciech'}).should eql true
      end

      it 'should remove existing entity' do
        user_id = Factory.mongo_object_id
        user = User.new({'_id' => user_id})
        @mongo_collection.should_receive(:remove).
                          with({_id: {'$in' => [user_id]}}, {}) { true }

        @collection.remove(user).should eql true
      end

      it 'should save the entity with id and retain the id' do
        id = Factory.mongo_object_id
        @mongo_collection.should_receive(:save).with({
          :_id => id,
          :name => 'Hubert',
          :_class => 'User'
        }, {}) { id }
        user = User.new('name' => 'Wojciech', '_id' => id)
        user.name = 'Hubert'
        @collection.save(user).should eql id
      end

      it 'should save the entity without id and assign an id' do
        id = Factory.mongo_object_id
        @mongo_collection.should_receive(:save).with({
          :name => 'Hubert',
          :_class => 'User'
        }, {}) { id }
        user = User.new('name' => 'Wojciech')
        user.name = 'Hubert'
        @collection.save(user).should eql id
      end

      it 'should update the collection' do
        id = Factory.mongo_object_id
        @mongo_collection.should_receive(:update).
                          with({'name' => 'Hubert'},
                            {'$set' => {'name' => 'Wojciech'}}, {})

        @collection.update({'name' => 'Hubert'},
                           {'$set' => {'name' => 'Wojciech'}})
      end

      it 'should find entities without a block' do
        selector = {name: 'Wojciech'}
        cursor = mock('Mongo::Cursor')
        @mongo_collection.should_receive(:find).with(selector, {}) { cursor }

        @collection.find(selector).should be_instance_of Montgomery::Cursor
      end

      it 'should find entities with a block' do
        selector = {name: 'Wojciech'}
        mongo_cursor = mock('Mongo::Cursor')
        @mongo_collection.should_receive(:find).with(selector, {}).and_yield(mongo_cursor)

        @collection.find(selector) do |cursor|
          cursor.should be_instance_of Montgomery::Cursor
        end
      end
    end
  end
end
