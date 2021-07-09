namespace 'citizens' do
  get ':id/products/:product_id', to: 'products#show'
end

