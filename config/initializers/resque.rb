Resque::Server.use(Rack::Auth::Basic) do |user, password|
  user = ENV['ADMIN_LOGIN']
  password = ENV['ADMIN_PWD']
end

if Rails.env.local?
  Resque.logger.formatter = Resque::VeryVerboseFormatter.new
end
