scope :auth do
  resources :brands, only: [:create]
end