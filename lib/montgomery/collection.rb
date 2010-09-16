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

  def find_and_modify(options={})
    doc = @mongo_collection.find_and_modify(options)
    self.class.doc_to_entity(doc)
  end

  def find_one(spec_or_object_id=nil, options={})
    doc = @mongo_collection.find_one(spec_or_object_id, options)
    self.class.doc_to_entity(doc)
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

  private

  def self.doc_to_entity(doc)
    return unless doc

    klass_name = doc.delete('_class')
    klass = Kernel.const_get(klass_name)
    klass.new(doc)
  end
end
