require 'support/test_classes'

RSpec.describe PerformLater::Messages::EnqueuedMessage do
  let(:klass) { PerformLater::Messages::EnqueuedMessage }
  let(:object){ klass.new(worker_class, method, id) }
  let(:worker_class){ Class.new }
  let(:method){ :foo }
  let(:id){ rand(10000).to_s(16) }


  it "responds to merge" do
    expect(object).to respond_to(:merge)
  end

  describe "attributes" do
    it "exposes the class name" do
      expect(object[:class]).to eq(worker_class.name)
    end
    it "exposes the method" do
      expect(object[:method]).to eq(method)
    end
    it "exposes the job id" do
      expect(object[:job_id]).to eq(id)
    end
  end

  describe "inspect" do
    it "is plainly readable" do
      expect(object.inspect).to eq "#{worker_class.name}#foo queued for later execution. job_id=#{id}"
    end
  end
end