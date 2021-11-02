get '/product-jobs/:id', to: 'products/jobs#show', as: :product_job_status

namespace :products do
  resources :summaries do
    post :search, on: :collection
  end
  delete ':product_id/variants/:id', to: "variants#destroy_offline"
end

scope :products do
  post '', to: 'products#create_offline'
  put ':id', to: 'products#update_offline'
  get ':id', to: 'products#show'
  delete ':id', to: 'products#destroy_offline'
  get ':id/reviews', to: 'products/reviews#index'
  post ':id/variants', to: 'products/variants#create_offline'

end

scope :auth do
  put 'products/:id', to: 'products#update'
  delete 'products/:id', to: 'products#destroy'
  namespace :products do
    post ":id/reviews", to: "reviews#create"
    delete ':product_id/variants/:id', to: "variants#destroy"
    post ':id/variants', to: 'variants#create'
  end
  post '/citizens/self/products', to: 'citizens/products#create'
  post '/shops/self/products', to: 'shops/products#create'
end
