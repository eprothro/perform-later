RSpec.describe PerformLater do
  class WorkTracker
    include PerformLater

    perform_later :call
    def call
      called!
    end

    def called
      @called
    end

    def called!
      @called = true
    end
  end
  let(:klass) { WorkTracker }

  describe "call_later" do

    it "is called" do
      object = nil
      expect_any_instance_of(WorkTracker).to receive(:call) do | o |
        object = o
        o.called!
      end

      klass.call_later
      expect(object.called).to eq(true)
    end
  end
end