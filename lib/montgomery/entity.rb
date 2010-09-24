module Montgomery::Entity
  autoload :Attribute, 'montgomery/entity/attribute'
  autoload :Id, 'montgomery/entity/id'

  def self.included(base)
    base.class_eval do
      include Montgomery::Entity::Attribute
      include Montgomery::Entity::Id
    end
  end
end
