class EmptyTester
  include PerformLater
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