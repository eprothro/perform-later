require 'support/test_classes'

RSpec.describe PerformLater::Delegation do
  let(:klass) { DoWorkWithSetupTester }
  let(:object){ klass.new }

  describe ".perform(:do_work, *params)" do

    it "calls after_initialize method" do
      expect(object).to receive(:setup)
      object.perform('do_work')
    end
    it "calls aliased method" do
      expect(object).to receive(:do_work)
      object.perform(:do_work)
    end

    context "with parameters" do
      let(:params){ [:baz, :bat] }

      it "passes params to after_initialize method" do
        expect(object).to receive(:setup).with(*params)
        object.perform('do_work', *params)
      end
    end
  end
end