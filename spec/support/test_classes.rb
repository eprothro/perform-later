class EmptyTester
  include PerformLater

  def do_work; end
end

class RequiredInitParamsTester
  include PerformLater

  attr_reader :foo, :bar

  def initialize(foo, bar)
    @foo, @bar = foo, bar
  end
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

  perform_later :do_work, after_deserialize: :deserialize

  def do_work; end

  private

  def deserialize(*args); end
end

class DoWorkWithSerializationTester
  include PerformLater

  perform_later :do_work, before_serialize: :serialize

  def do_work; end

  private

  def self.serialize(*args)
    args
  end
end