require "rails_helper"

RSpec.describe "routes for Products", :type => :routing do
  it { should route(:get, '/api/shops/26/products').to(controller: 'api/shops/products', action: :index, shop_id: 26) }
  it { should route(:get, '/api/shops/26/products/47671').to(controller: 'api/shops/products', action: :show, shop_id: 26, id: 47671) }
  it { should route(:post, '/api/auth/shops/26/products').to(controller: 'api/shops/products', action: :create, shop_id: 26) }
  it { should route(:post, '/api/shops/26/products').to(controller: 'api/shops/products', action: :create_offline, shop_id: 26) }
  it { should route(:delete, '/api/auth/shops/26/products/47671').to(controller: 'api/shops/products', action: :destroy, shop_id: 26, id: 47671) }
  it { should route(:delete, '/api/shops/26/products/47671').to(controller: 'api/shops/products', action: :destroy_offline, shop_id: 26, id: 47671) }

  it { should route(:put, '/api/auth/products/3432').to(controller: 'api/products', action: :update, id: 3432) }
  it { should route(:put, '/api/products/3432').to(controller: 'api/products', action: :update_offline, id: 3432) }
end