class Montgomery::Database < DelegateClass(Mongo::DB)
  def initialize(mongo_database)
    @mongo_database = mongo_database
    super(@mongo_database)
  end

  def collection(name, options={})
    mongo_collection = @mongo_database.collection(name, options)
    Montgomery::Collection.new mongo_collection: mongo_collection,
                               database: self
  end

  def collections
    @mongo_database.collections.map! do |c|
      Montgomery::Collection.new mongo_collection: c,
                                 database: self
    end
  end

  def create_collection(name, options={})
    mongo_collection = @mongo_database.create_collection(name, options)
    Montgomery::Collection.new mongo_collection: mongo_collection,
                               database: self
  end

  def to_mongo
    @mongo_database
  end
end
