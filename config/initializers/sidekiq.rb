require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISTOGO_URL']}
  Sidekiq::Status.configure_server_middleware config, expiration: 30.minutes
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISTOGO_URL']}
  Sidekiq::Status.configure_client_middleware config, expiration: 30.minutes
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user = ENV['ADMIN_LOGIN']
  password = ENV['ADMIN_PWD']
end