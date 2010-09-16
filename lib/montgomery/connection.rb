class Montgomery::Connection
  def initialize(host=nil, port=nil, options={})
    @mongo_connection = Mongo::Connection.new(host, port, options)
  end

  def database(name)
    Montgomery::Database.new @mongo_connection.db(name)
  end

  def db(name)
    raise 'Use #database instead of #db'
  end
end
