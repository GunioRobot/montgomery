require 'montgomery/entity/attribute'
require 'montgomery/entity/id'

module Montgomery
  module Entity
    def self.included(base)
      base.extend Montgomery::Entity::Attribute
      base.class_eval do
        include Montgomery::Entity::Id
      end
    end
  end
end
