require 'sidekiq'
require_relative 'perform-later/async_methods'
require_relative 'perform-later/proxy_methods'
require_relative 'perform-later/aliasing'
require_relative 'perform-later/logging'

module PerformLater
  def self.included(mod)
    async_mod = Module.new do
      include AsyncMethods
      extend self

      proxy_class = Class.new do
        include ProxyMethods
        self.klass = mod
      end
      const_set(:Proxy, proxy_class)
    end

    mod.class_eval do
      const_set(:Async, async_mod) unless const_defined?(:Async, false)
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