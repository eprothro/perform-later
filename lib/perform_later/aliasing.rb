require_relative 'delegation'

module PerformLater
  module Aliasing

    def self.extended(base)
      base.class_eval do
        # methods configured for execution
        # through an asyncronous bus.
        #
        # example:
        #   { :do_work => {after_initialize: :setup_from_async}}
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
    #      perform_later :do_work, after_initialize: :setup_from_async
    #
    #      private
    #
    #      def setup_from_async(arg1, arg2)
    #        @obj1 = Parser.parse(arg1)
    #        @obj2 = Lookup.lookup(arg2)
    #      end
    #    end
    def perform_later(method, opts={})
      self.perform_later_configs[method.to_s] = opts

      define_singleton_method "#{method}_later", ->(*args) do
        perform_async(method, *args)
      end
      singleton_class.send(:alias_method, "#{method}_async", "#{method}_later")
    end
  end
end