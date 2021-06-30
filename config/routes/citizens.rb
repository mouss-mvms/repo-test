class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/citizens/#{routes_name}.rb")))
  end
end

namespace :citizens do
  draw(:products)
end

