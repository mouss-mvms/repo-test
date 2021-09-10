get '/product-jobs/:id', to: 'products/jobs#show', as: :product_job_status
get '/product-summaries', to: 'products#index'

scope :products do
  post '', to: 'products#create_offline'
  put ':id', to: 'products#update_offline'
  get ':id', to: 'products#show'
  delete ':id', to: 'products#destroy_offline'
  get ':id/reviews', to: 'products/reviews#index'
end

scope :auth do
  post 'products', to: 'products#create'
  put 'products/:id', to: 'products#update'
  delete 'products/:id', to: 'products#destroy'
  namespace :products do
    post ":id/reviews", to: "reviews#create"
  end
end
