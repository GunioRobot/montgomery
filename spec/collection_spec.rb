require File.join(File.expand_path(File.dirname(__FILE__)), 'spec_helper')

describe 'Montgomery::Collection' do
  before do
    @collection = Montgomery::Collection.new(Mongo::Collection.new)
  end

  delegated_properties = [:hint, :hint=, :name, :pk_factory]
  delegated_methods = [:count, :create_index, :distinct, :drop, :drop_index, :drop_indexes, :group,
                      :index_information, :map_reduce, :options, :rename, :stats]

  (delegated_properties + delegated_methods).each do |message|
    it "should delegate #{message} to Mongo::Collection" do
      Mongo::Collection.any_instance.expects(message)
      @collection.send(message)

      Mongo::Collection.any_instance.expects(message).with(:args)
      @collection.send(message, :args)
    end
  end
end

