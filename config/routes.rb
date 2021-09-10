require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Sidekiq::Web.new, at: "/jobs"

  get '/' => "rails/welcome#index"

  namespace :api do
    namespace :v1 do
      instance_eval(File.read(Rails.root.join("config/routes/v1/shops.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/products.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/reviews.rb")))
      get '/citizens/:id/products', to: 'citizens/products#index'
      get '/categories', to: 'categories#index'
    end
  end
end
