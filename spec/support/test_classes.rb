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

class DoWorkWithSetupTester
  include PerformLater

  perform_later :do_work, after_initialize: :setup

  def do_work; end

  private

  def setup(*args); end
end