source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
#api-pagination
gem 'api-pagination'
gem 'pagy'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.2', '>= 1.2.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test, :local do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-byebug'
  gem "rspec-rails"
  gem "rswag-specs"
  gem "shoulda-matchers"
  gem "factory_bot_rails"
end

gem 'listen', '~> 3.3'
# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'figaro'

group :production do
  gem 'rails_12factor'
end

gem 'rack-attack'
gem 'rswag-api'
gem 'rswag-ui'

gem 'delayed_job_active_record'
gem 'sidekiq-status'

gem 'omniauth', '1.3.1'
gem 'simple_token_authentication', '~>1.0'

gem 'jwt'

#Cache
gem 'dalli'
gem 'memcachier'

source 'https://gem.fury.io/mvms/' do
  gem 'mvms-core', '2.5.281'
end
