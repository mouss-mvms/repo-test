require "sidekiq/web"

Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Sidekiq::Web.new, at: "/jobs"

  get "/" => "rails/welcome#index"

  namespace :api do
    namespace :v1 do
      instance_eval(File.read(Rails.root.join("config/routes/v1/admin.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/brands.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/products.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/reviews.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/shops.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/variants.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/selections.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/categories.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/tags.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/images.rb")))
      instance_eval(File.read(Rails.root.join("config/routes/v1/citizens.rb")))
    end
  end
end
