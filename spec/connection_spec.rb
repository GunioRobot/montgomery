require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Connection' do
  it 'should try to connect to MongoDB' do
    Mongo::Connection.expects(:new)
    Montgomery::Connection.new
  end

  describe 'when connected' do
    before do
      @connection = Montgomery::Connection.new
    end

    it 'should return a database from #database' do
      options = {test: true}
      Mongo::Connection.any_instance.expects(:db).with('montgomery', options)

      database = @connection.database('montgomery', options)
      database.should.be.an.instance_of(Montgomery::Database)
    end

    it 'should raise exception when calling #db' do
      lambda { @connection.db('montgomery') }.should.raise(RuntimeError)
    end

    it 'should return a database from #[]' do
      database = @connection['montgomery']
      database.should.be.an.instance_of(Montgomery::Database)
    end

    delegated_properties = [:arbiters, :auths, :checked_out, :host, :logger,
      :nodes, :port, :primary, :secondaries, :size, :sockets]
    delegated_methods = [:add_auth, :apply_saved_authentication, :clear_auths,
      :close, :connect, :connect_to_master, :connected?, :copy_database,
      :database_info, :database_names, :drop_database, :format_pair,
      :get_request_id, :pair_val_to_connection, :parse_uri, :receive_message,
      :remove_auth, :send_message, :send_message_with_safe_check, :server_info,
      :server_version, :slave_ok?]

    (delegated_properties + delegated_methods).each do |message|
      it "should delegate #{message} to Mongo::Collection" do
        Mongo::Connection.any_instance.expects(message)
        @connection.send(message)

        Mongo::Connection.any_instance.expects(message).with(:args)
        @connection.send(message, :args)
      end
    end
  end
end
