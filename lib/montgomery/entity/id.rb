module Montgomery
  module Entity
    module Id
      def self.included(base)
        base.extend Montgomery::Entity::Attribute
        base.class_eval do
          montgomery_attr_reader :_id
          alias_method :id, :_id
        end
      end

      protected

      attr_writer :_id
    end
  end
end
