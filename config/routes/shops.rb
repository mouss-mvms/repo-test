scope :auth do
  post "shops", to: "shops#create", as: nil
  put "shops/:id", to: "shops#update", as: nil
  namespace :shops do
    put ":id/schedules", to: "schedules#update"
  end
end

get "shops/:id", to: "shops#show", as: nil

namespace :shops do
  get ":id/products", to: "products#index"
  get ":id/schedules", to: "schedules#index"
end
