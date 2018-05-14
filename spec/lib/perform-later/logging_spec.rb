require 'support/test_classes'

RSpec.describe PerformLater::Logging do
  let(:klass) { DoWorkTester }
  let(:object){ klass.new }

  describe "logger" do
    it "returns logger" do
      expect(DoWorkTester.new.logger).to eq(PerformLater.logger)
    end
  end

  describe ".logger" do
    it "returns logger" do
      expect(DoWorkTester.logger).to eq(PerformLater.logger)
    end
  end
end