module Montgomery::Entity
  attr_reader :_id

  def initialize(doc={})
    doc.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def to_montgomery_doc
    doc = {}
    instance_variables.each do |var|
      key = var.to_s.gsub('@', '')
      value = instance_variable_get(var)
      doc[key] = value
    end
    doc['_class'] = self.class.to_s
    doc
  end
end
