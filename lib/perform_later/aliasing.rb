require_relative 'delegation'

module PerformLater
  module Aliasing

    def self.extended(base)
      base.class_eval do
        # methods configured for execution
        # through an asyncronous bus.
        #
        # example:
        #   { :do_work => {after_deserialize: :setup_from_async}}
        #
        # note: sidekiq has implementation of class_attribute
        class_attribute :perform_later_configs
        self.perform_later_configs = {}

        include Delegation
      end
    end

    # configre a method to be performed asyncronously
    #
    # ex:
    #    class Foo
    #
    #      def do_work
    #      end
    #
    #      perform_later :do_work, after_deserialize: :setup_from_async
    #
    #      private
    #
    #      def setup_from_async(arg1, arg2)
    #        @obj1 = Parser.parse(arg1)
    #        @obj2 = Lookup.lookup(arg2)
    #      end
    #    end
    def perform_later(method, opts={})
      config = opts.clone
      aliases = Array(config.delete(:as){ ["#{method}_later", "#{method}_async"] })
      self.perform_later_configs[method.to_s] = config

      entry_point = aliases.delete_at(0)
      define_singleton_method entry_point, ->(*args) do
        args = call_before_serialize(config[:before_serialize], args)
        perform_async(method, *args).tap { |id| logger.debug(Messages::EnqueuedMessage.new(self, method, id)) }
      end

      aliases.each do | entry_point_alias |
        singleton_class.send(:alias_method, entry_point_alias, entry_point)
      end
    end

    private

    def enqueued_payload

    end

    def call_before_serialize(call, args)
      case call
      when Symbol
        self.send(call, *args)
      else
        # null or unsupported call type, return untouched args
        args
      end
    end
  end
end