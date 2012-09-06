def cron_command
  root_path = File.expand_path(File.dirname(__FILE__) + "/../")

  "cd #{root_path} && RACK_ENV=production bundle exec bin/collector broadcast" +
      " >> #{root_path}/log/cron.out.log 2>> #{root_path}/log/cron.err.log"
end

every :hour do
  command cron_command
end
