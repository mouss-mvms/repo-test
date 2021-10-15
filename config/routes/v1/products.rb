get '/product-jobs/:id', to: 'products/jobs#show', as: :product_job_status

namespace :products do
  resources :summaries do
    post :search, on: :collection
  end
end

scope :products do
  post '', to: 'products#create_offline'
  put ':id', to: 'products#update_offline'
  get ':id', to: 'products#show'
  delete ':id', to: 'products#destroy_offline'
  get ':id/reviews', to: 'products/reviews#index'
end

scope :auth do
  put 'products/:id', to: 'products#update'
  delete 'products/:id', to: 'products#destroy'
  namespace :products do
    post ":id/reviews", to: "reviews#create"
  end
  post '/citizens/self/products', to: 'citizens/products#create'
  post '/shops/self/products', to: 'shops/products#create'
end
