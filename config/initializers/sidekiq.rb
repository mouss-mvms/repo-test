require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDISTOGO_URL']}
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDISTOGO_URL']}
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  user = ENV['ADMIN_LOGIN']
  password = ENV['ADMIN_PWD']
end