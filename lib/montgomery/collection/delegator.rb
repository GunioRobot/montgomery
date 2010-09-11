module Montgomery::Collection::Delegator
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def delegate(*methods)
      class_eval do
        methods.each do |method|
          define_method(method) do |*params|
            @mongo_collection.send(method, *params)
          end
        end
      end
    end
  end
end

