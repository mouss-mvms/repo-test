require "rails_helper"

RSpec.describe "routes for Products'Shop", :type => :routing do
  it { should route(:get, '/api/v1/auth/shops/self/products').to(controller: 'api/v1/shops/products', action: :index)}
end
