module PerformLater
  module AsyncMethods

    def serialize(*args)
      args
    end

    def deserialize(*args)
      proxy.klass.new()
    end

    def create_entry_point(method, opts={})
      opts = opts.clone
      aliases = Array(opts.delete(:as))
      aliases = ["#{method}_later", "#{method}_async"] if aliases.empty?

      entry_point = method
      define_singleton_method entry_point, ->(*args) do
        async_args = serialize(*args)

        proxy.perform_async(method, *async_args).tap do |id|
          proxy.klass.logger.debug(Messages::EnqueuedMessage.new(proxy.klass, method, id))
        end
      end

      aliases.each do | entry_point_alias |
        proxy.klass.define_singleton_method entry_point_alias, -> (*args) do
          const_get("Async", false).send(entry_point, *args)
        end
      end
    end

    private

    def proxy
      const_get("Proxy")
    end
  end
end



