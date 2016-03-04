module Cassandra
  class ConfigGenerator < Rails::Generators::Base

    def create_config
      if File.exist?(config_file_path)
        puts yellow("[skip] '#{file}' already exists")
      else
        puts green("[new] creating '#{file}'")

        opts = {
          app_name: app_name,
          destination_path: config_file_path
        }
        Cassie::Configuration::Generator.new(opts).save
      end
    end

    def finalize
      puts green('[done]')
    end

    private

    def config_file_path
      File.expand_path(file)
    end

    def file
      'config/cassandra.yml'
    end

    def app_name
      if defined?(Rails) && Rails.respond_to?(:application)
        Rails.application.class.parent_name.underscore
      else
        self.class.base_name
      end
    end

    def colorize(color_code, message)
      "\e[#{color_code}m#{message}\e[0m"
    end

    def green(message)
      colorize(32, message)
    end

    def yellow(message)
      colorize(33, message)
    end


  end
end