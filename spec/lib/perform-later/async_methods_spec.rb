RSpec.describe PerformLater do

  let(:klass) { DoWorkTester }
  let(:class_name) { "DoWorkTester" }
  let(:async_mod){ klass.const_get("Async") }
  let(:proxy_class){ klass.const_get("Async::Proxy") }

  describe "serialize" do
    it "returns empty array" do
      expect(async_mod.serialize).to eq([])
    end
    it "returns args" do
      expect(async_mod.serialize(:foo)).to eq([:foo])
    end
  end

  describe "deserialize" do
    it "returns object from Proxy class" do
      expect(async_mod.deserialize).to be_a DoWorkTester
    end
    it "accepts args" do
      expect(async_mod.deserialize(:foo)).to be_a DoWorkTester
    end
  end

  describe ".create_entry_point" do
    it "adds .do_work method to async class" do
      expect(async_mod).to respond_to(:do_work)
    end

    it "adds .do_work_later method to user class" do
      expect(klass).to respond_to(:do_work_later)
    end

    it "adds .do_work_async method to user class" do
      expect(klass).to respond_to(:do_work_async)
    end

    context "with the :as option" do
      context "using single method" do
        let(:klass){ DoWorkWithAsTester}

        it "adds method" do
          expect(klass).to respond_to(:entry_point_asynchronously)
        end
      end

      context "using array of methods" do
        let(:klass){ DoWorkWithArrayAsTester}

        it "adds first method" do
          expect(klass).to respond_to(:entry_point_asynchronously)
        end
        it "adds other methods" do
          expect(klass).to respond_to(:entry_point_alias_asynchronously)
        end
      end
    end

    describe ".do_work_later" do
      let(:params){ [:baz, :bat] }

      it "calls perform_async(:do_work, *params) on the proxy" do
        expect(proxy_class).to receive(:perform_async).with(:do_work, *params)
        klass.do_work_later(*params)
      end

      it "logs enqueueing as debug" do
        # run once to clear client logging
        klass.do_work_later(*params)
        expect(PerformLater.logger).to receive(:debug).with(a_kind_of(PerformLater::Messages::EnqueuedMessage))
        klass.do_work_later(*params)
      end

      it "logs enqueueing with correct attributes" do
        expect(PerformLater::Messages::EnqueuedMessage).to receive(:new).with(klass, :do_work, /[0-9a-f]*/)
        klass.do_work_later(*params)
      end

      context "when serialization is overwritten" do
        let(:klass) { DoWorkWithSerializationTester }
        let(:serialized_params){ params.map(&:hash) }

        it "calls hook" do
          expect(async_mod).to receive(:serialize).with(*params)
          klass.do_work_later(*params)
        end

        it "passes serialized params to perform_async" do
          expect(proxy_class).to receive(:perform_async).with(:do_work, *serialized_params)
          klass.do_work_later(*params)
        end
      end
    end
  end
end