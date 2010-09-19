module Montgomery::Delegator
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def delegate(*args)
      methods = args[0..-2]
      destination = args[-1][:to]
      class_eval do
        methods.each do |method|
          define_method(method) do |*params|
            instance_variable_get("@#{destination}").send(method, *params)
          end
        end
      end
    end
  end
end
