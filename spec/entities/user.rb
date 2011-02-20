class User
  include Montgomery::Entity

  montgomery_attr_accessor :name, :weight

  def initialize(values)
    @_id = values['_id']
    @name = values['name']
    @weight = values['weight']
  end
end
