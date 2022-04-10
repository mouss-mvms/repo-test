if Rails.env.test?
    require 'rake'
    # Unseat several DB tasks to prevent Heroku CI from running them on our suite.
    # There isn't currently a way to prevent Heroku CI from running these commands.
  
    enemy_tasks = %w[
      db:schema:load
      db:schema:load_if_ruby
      db:structure:load
      db:structure:load_if_sql      
    ]
  
    enemy_tasks.each do |task_name|
      begin
        if Rake::Task.task_defined?(task_name)
            Rake::Task[task_name].clear
        end
      desc "Do nothing"
      task task_name do
        Kernel.puts "#{task_name} has no effect in test mode"
      end
      rescue => e
        puts e.message
      end
    end
end