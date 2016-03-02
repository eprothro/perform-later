class CassandraConfigGenerator < Rails::Generators::NamedBase

  def add_colorization
    class String
      # colorization
      def colorize(color_code)
        "\e[#{color_code}m#{self}\e[0m"
      end

      def red
        colorize(31)
      end

      def green
        colorize(32)
      end

      def yellow
        colorize(33)
      end

      def blue
        colorize(34)
      end

      def pink
        colorize(35)
      end

      def light_blue
        colorize(36)
      end
    end
  end

  def create_config
    if File.exists?(config_path)
      puts "[skip] 'config/cassandra.yml' already exists".yellow
    else
      puts "[new] creating 'config/cassandra.yml'".green
      opts = {
        app_name: application_name,
        destination_path: config_file_path
      }
      Cassie::Configuration::Generator.new(opts).save
    end
  end

  def finalize
    puts '[done]'.green
  end

  private

  def config_file_path
    File.expand_path('config/cassandra.yml')
  end
end
