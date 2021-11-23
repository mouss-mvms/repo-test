scope :auth do
  resources :selections, only: [:create]
  patch 'selections/:id', to: 'selections#patch'
end