web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
release: rake db:migrate && rake data:migrate
