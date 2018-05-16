require 'support/test_classes'

RSpec.describe PerformLater::Aliasing do
  let(:klass) { DoWorkTester }
  let(:object){ klass.new }

  describe ".perform_later" do
    let(:async){ klass.const_get("Async", false) }
    let(:method){ "some_method" }
    let(:opts){ {as: :method_alias} }

    it "calls Proxy.create_entry_point" do
      expect(async).to receive(:create_entry_point).with(method, opts)
      klass.perform_later(method, opts)
    end
  end
end