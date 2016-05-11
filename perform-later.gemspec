Gem::Specification.new do |s|
  s.name        = 'perform-later'
  s.version     = '1.0.0.alpha.4'
  s.summary     = "Sidekiq support for ruby objects that encourages objected oriented design"
  s.description = <<-EOS.strip.gsub(/\s+/, ' ')
    perform-later provides asyncronous worker/job support for objects with a convention that encourages better object oriented design.
    It is a simple and lightweight adapter that helps decouple job/worker initialization from object behavior/logic/algorithm.
    It helps encourage objects with async/job/worker behavior that are more maintainable, easier to change, and faster to test thoroughly.
  EOS
  s.authors     = ["Evan Prothro"]
  s.email       = 'evan.prothro@gmail.com'
  s.files      += Dir['lib/**/*.*']
  s.homepage    = 'https://github.com/eprothro/perform-later'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.2.0'


  s.add_dependency 'sidekiq', '>= 3.0'

  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'generator_spec', '~> 0.9'
  s.add_development_dependency 'byebug', '>= 0'
  s.add_development_dependency 'benchmark-ips', '>= 0'
end