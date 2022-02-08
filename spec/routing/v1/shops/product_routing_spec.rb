require "rails_helper"

RSpec.describe "routes for Products' Shop", :type => :routing do
  it { should route(:get, '/api/v1/auth/shops/self/products').to(controller: 'api/v1/shops/products', action: :index)}
  it { should route(:post, '/api/v1/auth/shops/self/products/35/reject').to(controller: 'api/v1/shops/products', action: :reject, id: 35)}
end
