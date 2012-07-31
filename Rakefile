require 'rubygems'
require 'rspec/core/rake_task'

task :default => :spec
task :test => :spec

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'test/*_spec.rb'
  task.rspec_opts = ["--color --format documentation"]
end
