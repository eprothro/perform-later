module PerformLater
  module Aliasing

    # configre a method to be performed asyncronously
    #
    # ex:
    #    class Foo
    #
    #      def do_work
    #      end
    #
    #      perform_later :do_work
    #
    #    end
    def perform_later(method, opts={})
      const_get("Async", false).create_entry_point(method, opts)
    end
  end
end