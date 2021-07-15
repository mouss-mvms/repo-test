class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/shops/#{routes_name}.rb")))
  end
end

scope :auth do
  post "shops", to: "shops#create", as: nil
  put "shops/:id", to: "shops#update", as: nil
end

get "shops/:id", to: "shops#show", as: nil

namespace :shops do
  get ":id/products", to: "products#index"
end
