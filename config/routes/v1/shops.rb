scope :auth do
  post "shops", to: "shops#create", as: nil
  put "shops/:id", to: "shops#update", as: nil
  namespace :shops do
    put ":id/schedules", to: "schedules#update"
    post ":id/reviews", to: "reviews#create"
    put ":id/deliveries", to: "deliveries#update"
    instance_eval(File.read(Rails.root.join("config/routes/v1/shops/products.rb")))
  end
end

namespace :shops do
  get ":id/products", to: "products#index"
  get ":id/schedules", to: "schedules#index"
  get ":id/deliveries", to: "deliveries#index"
  get ":id/reviews", to: "reviews#index"
  resources :summaries do
    post :search, on: :collection
  end
end

get "shops/:id", to: "shops#show", as: nil