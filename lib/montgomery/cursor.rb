class Montgomery::Cursor < DelegateClass(Mongo::Cursor)
  include Enumerable

  attr_reader :collection

  def initialize(values)
    @mongo_cursor = values[:mongo_cursor]
    @collection = values[:collection]
    super(@mongo_cursor)
  end

  def each
    @mongo_cursor.each do |doc|
      yield Montgomery::Mapper.from_doc(doc)
    end
  end

  def next_entity
    doc = @mongo_cursor.next_document
    Montgomery::Mapper.from_doc(doc)
  end

  alias_method :next_document, :next_entity

  def to_a
    docs = @mongo_cursor.to_a
    docs.map { |doc| Montgomery::Mapper.from_doc(doc) }
  end

  def to_mongo
    @mongo_cursor
  end
end
