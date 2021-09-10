require "rails_helper"

RSpec.describe "routes for Review", :type => :routing do
  it { should route(:post, '/api/v1/auth/products/26/reviews').to(controller: 'api/v1/products/reviews', action: :create, id: 26) }
  it { should route(:post, '/api/v1/auth/shops/26/reviews').to(controller: 'api/v1/shops/reviews', action: :create, id: 26) }
  it { should route(:put, '/api/v1/auth/reviews/26').to(controller: 'api/v1/reviews', action: :update, id: 26) }
  it { should route(:delete, '/api/v1/auth/reviews/26').to(controller: 'api/v1/reviews', action: :destroy, id: 26) }
end
