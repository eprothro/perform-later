module PerformLater::Messages
  class EnqueuedMessage < SimpleDelegator

    def initialize(klass, method, id)
      super({ enqueued_class: klass.name,
              enqueued_method: method,
              enqueued_job_id: id,
              msg: "queued for later execution" })
    end

    def inspect
      "#{fetch(:enqueued_class)}##{fetch(:enqueued_method)} #{fetch(:msg)}. enqueued_job_id=#{fetch(:enqueued_job_id)}"
    end

    def to_s
      inspect
    end
  end
end