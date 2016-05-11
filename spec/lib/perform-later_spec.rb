RSpec.describe PerformLater do
  class EmptyTester
    include PerformLater
  end
  let(:klass) { EmptyTester }
  let(:object){ klass.new }

  it "includes Sidkiq::Worker" do
    expect(klass.ancestors).to include Sidekiq::Worker
  end
end