class Montgomery::Collection
  autoload :Delegator, 'montgomery/collection/delegator'

  include Montgomery::Collection::Delegator

  # properties
  delegate :hint, :hint=, :name, :pk_factory

  # methods
  delegate :count, :create_index, :distinct, :drop, :drop_index, :drop_indexes,
           :group, :index_information, :map_reduce, :options, :rename, :stats

  def initialize(mongo_collection)
    @mongo_collection = mongo_collection
  end

  def [](subcollection_name)
    Montgomery::Collection.new(@mongo_collection[subcollection_name])
  end

  def find(*args)
    raise 'Not implemented'
  end

  def find_and_modify(*args)
    raise 'Not implemented'
  end

  def find_one(*args)
    raise 'Not implemented'
  end

  def insert(*args)
    raise 'Not implemented'
  end

  def remove(*args)
    raise 'Not implemented'
  end

  def save(*args)
    raise 'Not implemented'
  end

  def update(*args)
    raise 'Not implemented'
  end
end
