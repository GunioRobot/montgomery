module Montgomery::Entity::Id
  def self.included(base)
    base.class_eval do
      montgomery_attr_reader :_id
      alias_method :id, :_id
    end
  end

  private

  # avoid "warning: private attribute?"
  def _id=(bson_id)
    @_id = bson_id
  end

  alias_method :id=, :_id=
end
