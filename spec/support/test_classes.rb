class EmptyTester
  include PerformLater

  def do_work; end
end

class DoWorkTester
  include PerformLater

  perform_later :do_work

  def do_work; end
end

class DoWorkWithAsTester
  include PerformLater

  perform_later :do_work, as: 'entry_point_asynchronously'

  def do_work; end
end

class DoWorkWithArrayAsTester
  include PerformLater

  perform_later :do_work, as: ['entry_point_asynchronously', :entry_point_alias_asynchronously]

  def do_work; end
end

class DoWorkWithDeserializationTester
  include PerformLater
  attr_accessor :foo

  perform_later :do_work

  def do_work; end

  module Async
    def deserialize(arg1)
      DoWorkWithDeserializationTester.new.tap do |o|
        o.foo = arg1
      end
    end
  end
end

class DoWorkWithSerializationTester
  include PerformLater

  perform_later :do_work

  def do_work; end

  module Async
    def serialize(*args)
      args.map{ |a| a.hash }
    end
  end
end