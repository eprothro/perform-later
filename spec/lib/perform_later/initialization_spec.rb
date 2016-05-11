require 'support/test_classes'

RSpec.describe PerformLater::Initialization do
  let(:klass) { EmptyTester }
  let(:object){ klass.new }

  context "when parameters are required" do
    let(:klass) { RequiredInitParamsTester }
    let(:object){ klass.new(:foo, :bar) }

    describe "new" do
      it "receives params" do
        expect(object.foo).to eq(:foo)
        expect(object.bar).to eq(:bar)
      end
    end

    describe ".perform_async" do
      it "doesn't raise due to required initialization parameters" do
        allow_any_instance_of(klass).to receive(:perform)
        klass.perform_async(:do_work)
      end
    end
  end
end