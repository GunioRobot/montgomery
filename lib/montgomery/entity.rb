module Montgomery::Entity
  attr_reader :_id

  def initialize(doc={})
    # prevent warnings about unset @_id
    instance_variable_set(:@_id, nil) unless doc.has_key?('_id')

    doc.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def self.to_doc(entity)
    doc = {}
    entity.instance_variables.each do |var|
      key = var.to_s.gsub('@', '')
      value = entity.instance_variable_get(var)
      doc[key] = value
    end
    doc['_class'] = entity.class.to_s
    # _id == nil will cause MongoDB to insert without setting ObjectId
    doc.delete('_id') unless doc['_id']
    doc
  end

  def self.from_doc(doc)
    return unless doc

    klass_name = doc.delete('_class')
    klass = Kernel.const_get(klass_name)
    klass.new(doc)
  end
end
