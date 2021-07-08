Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  get '/' => "rails/welcome#index"

  namespace :api do
    instance_eval(File.read(Rails.root.join("config/routes/shops.rb")))
    instance_eval(File.read(Rails.root.join("config/routes/products.rb")))
    get '/citizens/:id/products/:id', to: 'citizens/products#show'
    get '/categories', to: 'categories#index'
  end

end
