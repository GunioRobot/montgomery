class Montgomery::Database < DelegateClass(Mongo::DB)
  def initialize(mongo_database)
    @mongo_database = mongo_database
    super(@mongo_database)
  end

  def collection(name)
    Montgomery::Collection.new mongo_collection: @mongo_database.collection(name),
                               database: self
  end

  def to_mongo
    @mongo_database
  end
end
