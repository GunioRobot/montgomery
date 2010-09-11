class Montgomery::Collection
  autoload :Delegator, 'montgomery/collection/delegator'

  include Delegator

  # properties
  delegate :hint, :hint=, :name, :pk_factory

  # methods
  delegate :count, :create_index, :distinct, :drop, :drop_index, :drop_indexes, :group,
           :index_information, :map_reduce, :options, :rename, :stats

  def initialize(mongo_collection)
    @mongo_collection = mongo_collection
  end

  def [](subcollection_name)
    Montgomery::Collection.new(@mongo_collection[subcollection_name])
  end
end

