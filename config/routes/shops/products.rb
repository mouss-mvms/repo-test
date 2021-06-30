get ":shop_id/products", to: "products#index"
get ":shop_id/products/:id", to: "products#show"
post ":shop_id/products", to: "products#create_offline"
put ":shop_id/products/:id", to: "products#update_offline"
delete ":shop_id/products/:id", to: "products#destroy_offline"

