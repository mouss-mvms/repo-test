scope :auth do
  patch 'variants/:id', to: 'variants#update'
end

patch 'variants/:id', to: 'variants#update_offline'
