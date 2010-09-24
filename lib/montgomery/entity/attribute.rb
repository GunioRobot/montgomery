module Montgomery::Entity::Attribute
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def montgomery_attr_accessor(*attributes)
      attr_accessor(*attributes)
      montgomery_attrs.concat attributes
    end

    def montgomery_attr_reader(*attributes)
      attr_reader(*attributes)
      montgomery_attrs.concat attributes
    end

    def montgomery_attrs
      @montgomery_attrs ||= []
    end
  end
end
