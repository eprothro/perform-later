module Cassie::Configuration
  class MissingClusterConfiguration < StandardError

    def generation_instructions
      "Generate #{path} by running `rails g cassandra:config`"
    end
  end
end