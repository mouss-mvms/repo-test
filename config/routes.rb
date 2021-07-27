require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Sidekiq::Web.new, at: "/jobs"

  get '/' => "rails/welcome#index"

  namespace :api do
    instance_eval(File.read(Rails.root.join("config/routes/shops.rb")))
    instance_eval(File.read(Rails.root.join("config/routes/products.rb")))
    get '/citizens/:id/products', to: 'citizens/products#index'
    get '/categories', to: 'categories#index'
  end
end
