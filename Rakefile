require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec

  Rake::Task[:build].enhance ["spec"]

rescue LoadError
  # no rspec available, don't add rspec tasks
end
