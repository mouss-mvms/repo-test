scope :auth do
  resources :selections, only: [:create]
end

resources :selections, only: [:index, :show]