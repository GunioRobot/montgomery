class Montgomery::Connection
  include Montgomery::Delegator

  # properties
  delegate :arbiters, :auths, :checked_out, :host, :logger,
      :nodes, :port, :primary, :secondaries, :size, :sockets,
      to: :mongo_connection

  # methods
  delegate :add_auth, :apply_saved_authentication, :clear_auths,
      :close, :connect, :connect_to_master, :connected?, :copy_database,
      :database_info, :database_names, :drop_database, :format_pair,
      :get_request_id, :pair_val_to_connection, :parse_uri, :receive_message,
      :remove_auth, :send_message, :send_message_with_safe_check, :server_info,
      :server_version, :slave_ok?, to: :mongo_connection

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
