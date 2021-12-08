scope :auth do
  namespace :admin do
    resources :selections, only: [:index, :show]

    namespace :selections do
      get ':id/products', to: 'products#index'
    end
  end
end