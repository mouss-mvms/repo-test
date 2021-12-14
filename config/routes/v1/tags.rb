resources :tags, only: [:index, :show] do end

namespace :tags, path: 'tags/:id' do
  get 'products', to: 'products#index'
end
