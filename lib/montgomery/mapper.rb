module Montgomery::Mapper
  def self.to_doc(entity)
    doc = {}
    entity.class.montgomery_attrs.each do |attribute|
      doc[attribute] = entity.send(attribute)
    end
    doc[:_class] = entity.class.to_s
    # _id == nil will cause MongoDB to insert without setting ObjectId
    doc.delete(:_id) unless doc[:_id]
    doc
  end

  def self.from_doc(doc)
    return unless doc

    klass_name = doc.delete('_class')
    klass = Kernel.const_get(klass_name)
    klass.new(doc)
  end
end
