class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/auth/#{routes_name}.rb")))
  end
end

namespace :auth do
  draw(:shops)
end
