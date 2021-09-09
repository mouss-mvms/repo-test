scope :auth do
  put '/reviews/:id', to: 'reviews#update'
end

