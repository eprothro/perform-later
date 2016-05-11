require 'support/test_classes'

RSpec.describe PerformLater::Aliasing do
  let(:klass) { DoWorkWithSetupTester }
  let(:object){ klass.new }

  describe ".perform_later" do
    it "adds .do_work_later method" do
      expect(klass).to respond_to(:do_work_later)
    end
  end

  describe ".do_work_later" do
    let(:params){ [:baz, :bat] }

    it "calls perform_async(:do_work, *params)" do
      expect(klass).to receive(:perform_async).with(:do_work, *params)
      klass.do_work_later(*params)
    end
  end

  describe ".do_work_async" do
    let(:params){ [:baz, :bat] }

    it "calls perform_async(:do_work, *params)" do
      expect(klass).to receive(:perform_async).with(:do_work, *params)
      klass.do_work_async(*params)
    end
  end

  describe "Sidekiq.perform_async" do
    it "trip through async bus stringifies method symbol" do
      method = :foo
      expect_any_instance_of(klass).to receive(:perform).with(method.to_s)
      klass.perform_async(method)
    end
  end
end