require "rails_helper"

RSpec.describe "routes for (shop) product images", :type => :routing do
  it { should route(:delete, '/api/v1/auth/shops/self/products/21/images/35').to(controller: 'api/v1/shops/products/images', action: :destroy, product_id: 21, id: 35) }
end