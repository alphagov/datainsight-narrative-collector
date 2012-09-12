namespace :collect do
  desc "Initially collect Google Analytics data"
  task :init do
    rack_env = ENV.fetch('RACK_ENV', 'development')
    root_path = File.expand_path(File.dirname(__FILE__) + "/../../")
    sh %{cd #{root_path} && RACK_ENV=#{rack_env} bundle exec bin/collector broadcast}
  end
end