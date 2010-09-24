class User
  include Montgomery::Entity

  montgomery_attr_reader :_id, :name
  attr_writer :name

  def initialize(values)
    @_id = values['_id']
    @name = values['name']
  end
end
