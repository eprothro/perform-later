RSpec.describe PerformLater do
  class Resource
    attr_accessor :id

    def initialize(id)
      @id = id || 0
    end

    def do_work
    end

    def self.find_by_id(id)
      new(id)
    end
  end
  class TransientWorker
    include PerformLater
    attr_accessor :resource

    def initialize(resource)
      @resource = resource
    end

    def call
      resource.do_work
    end
    perform_later :call

    module Async
      def serialize(resource)
        resource.id
      end

      def deserialize(id)
        resource = Resource.find_by_id(id)
        TransientWorker.new(resource)
      end
    end
  end

  let(:klass) { TransientWorker }
  let(:resource) { Resource.new(id) }
  let(:id){ rand(100) + 1 }

  describe "call_later" do

    it "calls do work" do
      expect_any_instance_of(Resource).to receive(:do_work)

      klass.call_later(resource)
    end
    it "loads from id" do
      object = nil
      expect_any_instance_of(Resource).to receive(:do_work) do | o |
        object = o
      end

      klass.call_later(resource)
      expect(object.id).to eq(id)
    end
  end
end