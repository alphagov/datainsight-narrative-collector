require 'rubygems'
Dir.glob('lib/tasks/*.rake').each { |r| import r }

unless ENV["RACK_ENV"] == "production"
  require 'rspec/core/rake_task'
  require 'ci/reporter/rake/rspec'

  task :default => :spec

  RSpec::Core::RakeTask.new do |task|
    task.pattern = 'spec/*_spec.rb'
    task.rspec_opts = ["--color --format documentation"]
  end

end
