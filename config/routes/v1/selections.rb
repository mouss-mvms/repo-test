scope :auth do
  resources :selections, only: [:create]
  patch 'selections/:id', to: 'selections#patch'
end

resources :selections, only: [:index, :show]

namespace :selections do
  get ':id/products', to: 'products#index'
end