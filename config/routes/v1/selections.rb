scope :auth do
  resources :selections, only: [:create, :destroy]
  patch 'selections/:id', to: 'selections#patch'

  namespace :selections do
    post ':selection_id/products/:id', to: 'products#add'
    delete ':selection_id/products/:id', to: 'products#remove'
  end
end

resources :selections, only: [:index, :show]

namespace :selections do
  get ':id/products', to: 'products#index'
end