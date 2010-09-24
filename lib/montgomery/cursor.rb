class Montgomery::Cursor
  include Enumerable
  include Montgomery::Delegator

  attr_reader :collection

  # properties
  delegate :batch_size, :fields, :full_collection_name, :hint, :order,
    :selector, :snapshot, :timeout, to: :mongo_cursor

  # methods
  delegate :close, :closed?, :count, :explain, :has_next?, :inspect, :limit,
    :query_options_hash, :query_opts, :rewind!, :skip, :sort, to: :mongo_cursor

  def initialize(values)
    @mongo_cursor = values[:mongo_cursor]
    @collection = values[:collection]
  end

  def each
    @mongo_cursor.each do |doc|
      yield Montgomery::Mapper.from_doc(doc)
    end
  end

  def next_document
    raise 'Use #next_entity instead of #next_document'
  end

  def next_entity
    doc = @mongo_cursor.next_document
    Montgomery::Mapper.from_doc(doc)
  end

  def to_a
    docs = @mongo_cursor.to_a
    docs.map { |doc| Montgomery::Mapper.from_doc(doc) }
  end

  def to_mongo
    @mongo_cursor
  end
end
