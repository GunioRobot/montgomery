class Montgomery::Cursor
  def initialize(mongo_cursor)
    @mongo_cursor = mongo_cursor
  end

  def to_a
    docs = @mongo_cursor.to_a
    docs.map { |doc| Montgomery::Entity.from_doc(doc) }
  end
end
