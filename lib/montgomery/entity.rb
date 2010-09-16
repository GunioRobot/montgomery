module Montgomery::Entity
  attr_reader :_id

  def initialize(doc={})
    doc.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
