scope :auth do
  resources :brands, only: [:create]
end

namespace :brands do
  resources :summaries, only: [:index] do
    post :search, on: :collection
  end
end