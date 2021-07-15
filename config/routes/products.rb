put '/auth/products/:id', to: 'products#update'
put '/products/:id', to: 'products#update_offline'
get '/products/:id', to: 'products#show'
post '/auth/products', to: 'products#create'
post '/products', to: 'products#create_offline'
delete '/auth/products/:id', to: 'products#destroy'
delete '/products/:id', to: 'products#destroy_offline'
