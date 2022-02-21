scope :auth do
  resources :images, only: [:create]

  scope :avatar do
    delete 'images/:id', to: 'images#destroy_avatar'
  end
end