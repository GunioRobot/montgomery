class Montgomery::Collection
  autoload :Delegator, 'montgomery/collection/delegator'

  include Montgomery::Collection::Delegator

  attr_reader :database

  # properties
  delegate :hint, :hint=, :name, :pk_factory

  # methods
  delegate :count, :create_index, :distinct, :drop, :drop_index, :drop_indexes,
           :group, :index_information, :map_reduce, :mapreduce, :options,
           :rename, :stats

  def initialize(values)
    @mongo_collection = values[:mongo_collection]
    @database = values[:database]
  end

  def [](subcollection_name)
    Montgomery::Collection.new mongo_collection: @mongo_collection[subcollection_name],
                               database: @database
  end

  def db
    raise 'Use #database instead of #db'
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

  alias_method :<<, :insert

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
