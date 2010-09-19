class Montgomery::Collection
  include Montgomery::Delegator

  attr_reader :database

  # properties
  delegate :hint, :hint=, :name, :pk_factory, to: :mongo_collection

  # methods
  delegate :count, :create_index, :distinct, :drop, :drop_index, :drop_indexes,
           :group, :index_information, :map_reduce, :mapreduce, :options,
           :rename, :stats, to: :mongo_collection

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

  def find(selector={}, options={}, &block)
    if block
      @mongo_collection.find(selector, options) do |mongo_cursor|
        montgomery_cursor = Montgomery::Cursor.new(mongo_cursor)
        block.call(montgomery_cursor)
      end
    else
      mongo_cursor = @mongo_collection.find(selector, options)
      Montgomery::Cursor.new(mongo_cursor)
    end
  end

  def find_and_modify(options={})
    doc = @mongo_collection.find_and_modify(options)
    Montgomery::Entity.from_doc(doc)
  end

  def find_one(spec_or_object_id=nil, options={})
    doc = @mongo_collection.find_one(spec_or_object_id, options)
    Montgomery::Entity.from_doc(doc)
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
  end

  def save(entity, options={})
    doc = entity.to_montgomery_doc
    id = @mongo_collection.save(doc, options)
    doc.instance_variable_set(:@_id, id)
    id
  end

  def update(selector_or_entity_or_entities, document, options={})
    selector = to_selector(selector_or_entity_or_entities)
    @mongo_collection.update(selector, document, options)
  end

  private

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
