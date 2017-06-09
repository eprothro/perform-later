module PerformLater::Messages
  class EnqueuedMessage < SimpleDelegator

    def initialize(klass, method, id)
      super({ class: klass.name,
              method: method,
              job_id: id,
              msg: "queued for later execution" })
    end

    def inspect
      "#{fetch(:class)}##{fetch(:method)} #{fetch(:msg)}. job_id=#{fetch(:job_id)}"
    end

    def to_s
      inspect
    end
  end
end