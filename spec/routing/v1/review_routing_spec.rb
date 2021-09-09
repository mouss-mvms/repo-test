require "rails_helper"

RSpec.describe "routes for Review", :type => :routing do
  it { should route(:post, '/api/v1/auth/products/26/reviews').to(controller: 'api/v1/products/reviews', action: :create, id: 26) }
  it { should route(:post, '/api/v1/auth/shops/26/reviews').to(controller: 'api/v1/shops/reviews', action: :create, id: 26) }
  it { should route(:get, '/api/v1/products/26/reviews').to(controller: 'api/v1/products/reviews', action: :index, id: 26) }
end
