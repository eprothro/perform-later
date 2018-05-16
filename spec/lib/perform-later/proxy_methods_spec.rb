require 'support/test_classes'

RSpec.describe PerformLater::ProxyMethods do
  let(:klass) { DoWorkTester }
  let(:object){ klass.new }
  let(:async_mod){ klass.const_get("Async") }
  let(:proxy_class){ klass.const_get("Async::Proxy") }
  let(:proxy_object){ proxy_class.new }
  let(:params){ ["baz", "bat"] }

  describe ".perform_async" do
    it "stringifies method symbol through async bus" do
      method = :foo
      expect_any_instance_of(proxy_class).to receive(:perform).with(method.to_s)
      proxy_class.perform_async(method)
    end

    it "passes params" do
      method = :foo
      expect_any_instance_of(proxy_class).to receive(:perform).with(method.to_s, *params)
      proxy_class.perform_async(method, *params)
    end
  end

  describe ".perform" do
    before do
      allow(async_mod).to receive(:deserialize){ object }
    end

    it "calls deserialize method" do
      expect(async_mod).to receive(:deserialize)
      proxy_object.perform('do_work')
    end
    it "calls aliased method" do
      expect(object).to receive(:do_work)
      proxy_object.perform(:do_work)
    end

    context "with parameters" do

      it "passes params to after_deserialize method" do
        expect(async_mod).to receive(:deserialize).with(*params)
        proxy_object.perform('do_work', *params)
      end
    end
  end
end
