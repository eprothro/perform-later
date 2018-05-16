RSpec.describe PerformLater do

  let(:klass) { EmptyTester }
  let(:class_name) { "EmptyTester" }

  it "creates Async namespace" do
    expect(klass.const_defined?("Async", false)).to eq true
  end

  it "creates Async::Proxy namespace" do
    expect(klass.const_defined?("Async::Proxy")).to eq true
  end

  it "sets Async::Proxy.klass" do
    expect(eval("#{class_name}::Async::Proxy").klass).to eq klass
  end

  describe "Async module" do
    let(:mod){ klass.const_get("Async") }

    it "includes AsyncMethods" do
      expect(mod.included_modules).to include(PerformLater::AsyncMethods)
    end
  end

  describe "Async::Proxy class" do
    let(:proxy_class){ klass.const_get("Async::Proxy") }

    it "includes ProxyMethods" do
      expect(proxy_class.included_modules).to include(PerformLater::ProxyMethods)
    end
  end
end