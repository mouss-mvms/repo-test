put '/auth/products/:id', to: 'products#update'
put '/products/:id', to: 'products#update_offline'
get '/products/:id', to: 'products#show'
post '/auth/products', to: 'products#create'
post '/products', to: 'products#create_offline'
delete '/auth/products/:id', to: 'products#destroy'
delete '/products/:id', to: 'products#destroy_offline'
get '/product-jobs/:id', to: 'products/jobs#show', as: :product_job_status
get '/product-summaries', to: 'products#index'

scope :auth do
  namespace :products do
    post ":id/reviews", to: "reviews#create"
  end
end
