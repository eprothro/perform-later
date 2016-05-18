require 'support/test_classes'

RSpec.describe PerformLater::Aliasing do
  let(:klass) { DoWorkTester }
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

    context "when serialization hook exists" do
      let(:klass){ DoWorkWithSerializationTester }

      it "calls hook" do
        expect(klass).to receive(:serialize).with(*params)
        klass.do_work_later(*params)
      end
    end
  end

  describe ".do_work_async" do
    let(:params){ [:baz, :bat] }

    it "aliases perform_async(:do_work, *params)" do
      expect(klass.method(:do_work_async)).to eq(klass.method(:do_work_later))
    end
  end

  describe ".perform_async" do
    it "stringifies method symbol through async bus" do
      method = :foo
      expect_any_instance_of(klass).to receive(:perform).with(method.to_s)
      klass.perform_async(method)
    end
  end
end