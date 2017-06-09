module PerformLater
  module Delegation
    # receive the call from the asyncronous client
    # with the method we have setup to call
    # and the args to be passed to the deserialization hook
    def perform(method, *args)
      config = perform_later_configs[method] || {}
      call_after_deserialize(config[:after_deserialize], *args)

      self.send method
    end

    private

    def call_after_deserialize(call, *args)
      case call
      when Symbol
        self.send(call, *args)
      end
    end
  end
end