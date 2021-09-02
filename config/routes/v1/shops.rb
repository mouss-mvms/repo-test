scope :auth do
  post "shops", to: "shops#create", as: nil
  put "shops/:id", to: "shops#update", as: nil
  namespace :shops do
    put ":id/schedules", to: "schedules#update"
    post ":id/reviews", to: "reviews#create"
  end
end

get "shops/:id", to: "shops#show", as: nil
get "shops", to: "shops#index", as: nil
get "shop-summaries", to: "shops#shop_summaries", as: nil

namespace :shops do
  get ":id/products", to: "products#index"
  get ":id/schedules", to: "schedules#index"
  get ":id/deliveries", to: "deliveries#index"
end
