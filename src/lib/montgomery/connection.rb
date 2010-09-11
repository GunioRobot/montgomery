class Montgomery::Connection
  def initialize
    @mongo_connection = Mongo::Connection.new
  end

  def database(name)
    Montgomery::Database.new @mongo_connection.db(name)
  end

  def db(name)
    raise 'Use #database instead of #db'
  end
end

