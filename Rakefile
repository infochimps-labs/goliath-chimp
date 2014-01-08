require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

desc 'Run RSpec code examples with SimpleCov'
task :coverage do
  ENV['RACK_COVERAGE'] = 'true'
  Rake::Task[:spec].invoke
end

task default: [:spec]
