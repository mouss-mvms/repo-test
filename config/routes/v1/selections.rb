scope :auth do
  resources :selections, only: [:create, :destroy]
  patch 'selections/:id', to: 'selections#patch'
end