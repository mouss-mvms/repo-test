post 'products/:id/reject', to: 'products#reject'
resources :products, only: [:index] do
  delete 'images/:id', to: 'products/images#destroy'
end
