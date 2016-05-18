module PerformLater
  module Delegation

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