scope :auth do
  resources :selections, only: [:create]
end