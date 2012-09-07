root_path = File.expand_path(File.dirname(__FILE__) + "/../")
set :output, {
    :standard => "#{root_path}/log/cron.out.log",
    :error => "#{root_path}/log/cron.err.log"
}
job_type :collector, "cd :path && RACK_ENV=:environment bundle exec bin/collector :task :output"


every :hour do
  collector "broadcast", :environment => 'production'
end
