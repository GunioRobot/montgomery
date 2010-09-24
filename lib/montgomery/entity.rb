module Montgomery::Entity
  attr_reader :_id

  def initialize(doc={})
    # prevent warnings about unset @_id
    instance_variable_set(:@_id, nil) unless doc.has_key?('_id')

    doc.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end
end
