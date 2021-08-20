require "rails_helper"

RSpec.describe "routes for Products", :type => :routing do
  it { should route(:get, '/api/v1/shops/26/products').to(controller: 'api/v1/shops/products', action: :index, id: 26) }
  it { should route(:get, '/api/v1/products/47671').to(controller: 'api/v1/products', action: :show, id: 47671) }
  it { should route(:post, '/api/v1/auth/products').to(controller: 'api/v1/products', action: :create) }
  it { should route(:post, '/api/v1/products').to(controller: 'api/v1/products', action: :create_offline) }
  it { should route(:delete, '/api/v1/auth/products/47671').to(controller: 'api/v1/products', action: :destroy, id: 47671) }
  it { should route(:delete, '/api/v1/products/47671').to(controller: 'api/v1/products', action: :destroy_offline, id: 47671) }
  it { should route(:put, '/api/v1/auth/products/3432').to(controller: 'api/v1/products', action: :update, id: 3432) }
  it { should route(:put, '/api/v1/products/3432').to(controller: 'api/v1/products', action: :update_offline, id: 3432) }
  it { should route(:get, '/api/v1/product-jobs/8d540368705ea572a50b7401').to(controller: 'api/v1/products/jobs', action: :show, id: "8d540368705ea572a50b7401") }
  it { should route(:get, '/api/v1/product-summaries').to(controller: 'api/v1/products', action: :index) }
end