module PerformLater
  module ProxyMethods

    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include Sidekiq::Worker
      end
    end

    module ClassMethods
      def klass=(val)
        @klass = val
      end

      def klass
        @klass
      end
    end

    # Deserialize the args from the async bus
    # and call the method packed as the first arg
    # @note message call received from the asyncronous client
    def perform(method, *args)
      object = async_module.deserialize(*args)
      object.send method
    end

    private

    def async_module
      self.class.klass.const_get("Async")
    end
  end
end



