scope :auth do
  resources :images, only: [:create]
end