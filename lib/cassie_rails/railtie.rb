module CassieRails
  class Railtie < ::Rails::Railtie

    generators do
      Dir[File.expand_path("railties/**/*_generator.rb", File.dirname(__FILE__))].each do |file|
        require file
      end
    end
  end
end
