module Montgomery::Mapper
  def self.to_doc(entity)
    doc = {}
    entity.class.montgomery_attrs.each do |attribute|
      doc[attribute] = entity.send(attribute)
    end
    doc[:_class] = entity.class.to_s

    # BSON::ObjectId#== throws a warning here - let's silence it
    Montgomery::Silencer.silently do
      # _id == nil will cause MongoDB to insert without setting ObjectId
      doc.delete(:_id) if doc[:_id] == nil
    end

    doc
  end

  def self.from_doc(doc)
    return unless doc

    klass_name = doc.delete('_class')
    klass = Kernel.const_get(klass_name)
    entity = klass.new(doc)
    entity.send(:_id=, doc['_id'])
    entity
  end
end
