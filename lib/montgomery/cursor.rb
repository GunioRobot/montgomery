class Montgomery::Cursor
  include Montgomery::Delegator

  # properties
  delegate :batch_size, :fields, :full_collection_name, :hint, :order,
    :selector, :snapshot, :timeout, to: :mongo_cursor

  # methods
  delegate :close, :closed?, :count, :explain, :has_next?, :inspect, :limit,
    :query_options_hash, :query_opts, :rewind!, :skip, :sort, to: :mongo_cursor

  def initialize(mongo_cursor)
    @mongo_cursor = mongo_cursor
  end

  def to_a
    docs = @mongo_cursor.to_a
    docs.map { |doc| Montgomery::Entity.from_doc(doc) }
  end
end
