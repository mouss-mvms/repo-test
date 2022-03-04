require "rails_helper"

RSpec.describe "routes for (citizen) product images", :type => :routing do
  it { should route(:delete, '/api/v1/auth/citizens/self/products/42/images/12').to(controller: 'api/v1/citizens/products/images', action: :destroy, product_id: 42, id: 12) }
end