module PerformLater
  module Initialization
    def self.included(base)
      raise "#{self.name} must be prepended, not included for it to have any effect on #{base.name}"
    end

    def initialize(*args)
      # initialization with explicit
      # args, pass on
      if args.length > 0
        super(*args)
      else
        # initialization without args,
        # dynamically match message signature
        # with nil values
        super_params = method(__method__).super_method.parameters
        nil_args = Array.new(super_params.count{|param_array| param_array.first == :req}, nil)
        super(*nil_args)
      end
    end
  end
end