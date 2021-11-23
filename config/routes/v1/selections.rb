scope :auth do
  resources :selections, only: [:create]
end

resources :selections, only: [:index, :show]

namespace :selections do
  get ':id/products', to: 'products#index'
end