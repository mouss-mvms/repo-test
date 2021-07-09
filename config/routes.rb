Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  get '/' => "rails/welcome#index"

  namespace :api do
    instance_eval(File.read(Rails.root.join("config/routes/shops.rb")))
    instance_eval(File.read(Rails.root.join("config/routes/products.rb")))
    instance_eval(File.read(Rails.root.join("config/routes/citizens.rb")))
    get '/categories', to: 'categories#index'
  end

end
