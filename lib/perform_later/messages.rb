require 'delegate'
require_relative 'messages/enqueued_message'

module PerformLater
  # message classes that are hashes but inspect as readable strings
  # to support both string based and hash/json/kvp based log formatters
  module Messages
  end
end