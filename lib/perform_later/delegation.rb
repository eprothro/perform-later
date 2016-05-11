module PerformLater
  module Delegation

    def perform(method, *args)
      config = perform_later_configs[method] || {}
      call_after_initialize(config[:after_initialize], *args)

      self.send method
    end

    private

    def call_after_initialize(call, *args)
      case call
      when Symbol
        self.send(call, *args)
      end
    end
  end
end