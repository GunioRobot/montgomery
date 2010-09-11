class Montgomery::Database
  def initialize(mongo_database)
    @mongo_database = mongo_database
  end

  def collection(name)
    Montgomery::Collection.new @mongo_database.collection(name)
  end
end

