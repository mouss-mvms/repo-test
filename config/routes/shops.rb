class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/shops/#{routes_name}.rb")))
  end
end

scope :auth do
  namespace :shops do
    draw(:auth_products)
  end
end
namespace :shops do
  draw(:products)
end

get "shops/:id", to: "shops#show", as: nil
post "shops", to: "shops#create", as: nil
put "shops/:id", to: "shops#update", as: nil
