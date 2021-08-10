require "rails_helper"

RSpec.describe "routes for Products", :type => :routing do
  it { should route(:get, '/api/shops/26/products').to(controller: 'api/shops/products', action: :index, id: 26) }
  it { should route(:get, '/api/products/47671').to(controller: 'api/products', action: :show, id: 47671) }
  it { should route(:post, '/api/auth/products').to(controller: 'api/products', action: :create) }
  it { should route(:post, '/api/products').to(controller: 'api/products', action: :create_offline) }
  it { should route(:delete, '/api/auth/products/47671').to(controller: 'api/products', action: :destroy, id: 47671) }
  it { should route(:delete, '/api/products/47671').to(controller: 'api/products', action: :destroy_offline, id: 47671) }
  it { should route(:put, '/api/auth/products/3432').to(controller: 'api/products', action: :update, id: 3432) }
  it { should route(:put, '/api/products/3432').to(controller: 'api/products', action: :update_offline, id: 3432) }
  it { should route(:get, '/api/product-jobs/8d540368705ea572a50b7401').to(controller: 'api/products/jobs', action: :show, id: "8d540368705ea572a50b7401") }
end