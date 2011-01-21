class Montgomery::Connection < DelegateClass(Mongo::Connection)
  def self.from_uri(uri, options={})
    mongo_connection = Mongo::Connection.from_uri(uri, options)
    new(mongo_connection)
  end

  def self.multi(nodes, options={})
    mongo_connection = Mongo::Connection.multi(nodes, options)
    new(mongo_connection)
  end

  def initialize(host_or_mongo_connection=nil, port=nil, options={})
    case host_or_mongo_connection
    when Mongo::Connection
      @mongo_connection = host_or_mongo_connection
    else
      host = host_or_mongo_connection
      @mongo_connection = Mongo::Connection.new(host, port, options)
    end
    super(@mongo_connection)
  end

  def [](name)
    Montgomery::Database.new @mongo_connection[name]
  end

  def db(name, options={})
    Montgomery::Database.new @mongo_connection.db(name, options)
  end

  alias_method :database, :db

  def to_mongo
    @mongo_connection
  end
end
