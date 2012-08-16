require 'rubygems'
require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/*_spec.rb'
  task.rspec_opts = ["--color --format documentation"]
end
