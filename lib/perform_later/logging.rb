require_relative 'messages'

module PerformLater
  module Logging

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def logger
        PerformLater.logger
      end
    end

    def logger
      self.class.logger
    end
  end
end