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

  def insert(entity_or_entities, options={})
    entities = to_array(entity_or_entities)
    docs = entities.map(&:to_montgomery_doc)
    id_or_ids = @mongo_collection.insert(docs, options)
    ids = to_array(id_or_ids)
    entities.each_with_index do |entity, index|
      entity.instance_variable_set(:@_id, ids[index])
    end
    ids
  end

  alias_method :<<, :insert

  def remove(selector_or_entity_or_entities = {}, options = {})
    selector = to_selector(selector_or_entity_or_entities)
    @mongo_collection.remove(selector, options)
    true
  end

  def save(entity, options={})
    doc = entity.to_montgomery_doc
    id = @mongo_collection.save(doc, options)
    doc.instance_variable_set(:@_id, id)
    id
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

  def to_array(object_or_objects)
    object_or_objects.kind_of?(Array) ? object_or_objects : [object_or_objects]
  end

  def to_selector(selector_or_entity_or_entities)
    if selector_or_entity_or_entities.kind_of? Hash
      selector_or_entity_or_entities
    else
      entities = to_array(selector_or_entity_or_entities)
      ids = entities.map { |entity| entity._id }
      {_id: {'$in' => ids}}
    end
  end
end
