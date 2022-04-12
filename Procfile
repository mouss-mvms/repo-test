web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq
release: rake db:migrate && rails g mvms:core:copy_migrations && rake data:migrate
