scope :auth do
  patch 'variants/:id', to: 'variants#update'
end