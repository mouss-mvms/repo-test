require 'resque/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    ENV['QUEUE'] = '*'

    Resque.redis = ENV['REDISTOGO_URL']
  end
end

Resque.after_fork = Proc.new { ActiveRecord::Base.connected? }

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"