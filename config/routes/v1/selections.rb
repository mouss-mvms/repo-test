scope :auth do
  resources :selections, only: [:create]
  patch 'selections/:id', to: 'selections#patch'

  namespace :selections do
    post ':selection_id/products/:id', to: 'products#add'
    delete ':selection_id/products/:id', to: 'products#remove'
  end
end