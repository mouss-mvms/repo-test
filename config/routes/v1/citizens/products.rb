resources :products, only: [] do
  delete 'images/:id', to: 'products/images#destroy'
end