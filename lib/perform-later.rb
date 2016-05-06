require 'sidekiq'
require_relative 'perform_later/initialization'
require_relative 'perform_later/aliasing'

module PerformLater
  def self.included(base)
    base.class_eval do
      prepend Initialization
      include ::Sidekiq::Worker
      extend Aliasing
    end
  end
end