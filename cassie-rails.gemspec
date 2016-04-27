Gem::Specification.new do |s|
  s.name        = 'cassie-rails'
  s.version     = '1.0.0.alpha.8'
  s.summary     = "Rails Integration for Apache Cassandra application support"
  s.description = <<-EOS.strip.gsub(/\s+/, ' ')
    cassie-rails provides database configration, versioned migrations,
    efficient session management, and query classes. This allows Rails applications
    to use the functionality provided by the official `cassandra-driver` through
    lightweight and easy to use interfaces.
  EOS
  s.authors     = ["Evan Prothro"]
  s.email       = 'evan.prothro@gmail.com'
  s.files      += Dir['lib/**/*.*']
  s.homepage    = 'https://github.com/eprothro/cassie-rails'
  s.license     = 'MIT'

  s.add_runtime_dependency 'cassie', '~> 1.0.0.alpha'
  s.add_runtime_dependency 'rails', '>= 3.2'

  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'generator_spec', '~> 0.9'
  s.add_development_dependency 'byebug', '>= 0'
  s.add_development_dependency 'pry-rails', '>= 0'
  s.add_development_dependency 'benchmark-ips', '>= 0'
end