require "rails_helper"

RSpec.describe "routes for Variants", :type => :routing do
  it { should route(:patch, '/api/v1/auth/variants/42').to(controller: 'api/v1/variants', action: :update, id: 42) }
  it { should route(:delete, '/api/v1/auth/products/34/variants/42').to(controller: 'api/v1/products/variants', action: :destroy, product_id: 34, id: 42) }
  it { should route(:delete, '/api/v1/products/34/variants/42').to(controller: 'api/v1/products/variants', action: :destroy_offline, product_id: 34, id: 42) }
end