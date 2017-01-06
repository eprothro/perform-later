require 'sidekiq'
require_relative 'perform_later/initialization'
require_relative 'perform_later/aliasing'
require_relative 'perform_later/logging'

module PerformLater
  def self.included(base)
    base.class_eval do
      prepend Initialization
      include ::Sidekiq::Worker
      extend Aliasing
      include Logging
    end
  end

  def self.logger
    return @logger if defined?(@logger)
    @logger = init_logger
  end

  def self.logger=(val)
    @logger = val
  end

  def self.init_logger
    Sidekiq.logger
  end
end