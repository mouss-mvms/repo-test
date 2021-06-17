class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  require_relative 'routes/shops'
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  get '/' => "rails/welcome#index"

  namespace :api do
    draw(:shops)
    draw(:auth)
    get '/categories', to: 'categories#index'
  end

end
