class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/auth/shops/#{routes_name}.rb")))
  end
end

namespace :shops do
  draw(:products)
end
