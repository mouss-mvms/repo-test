class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  get '/' => "rails/welcome#index"

  namespace :api do
    draw(:products)
  end
end