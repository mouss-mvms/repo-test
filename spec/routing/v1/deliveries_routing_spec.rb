require "rails_helper"

RSpec.describe "routes for Deliveries", :type => :routing do
  it { should route(:get, '/api/v1/shops/26/deliveries').to(controller: 'api/v1/shops/deliveries', action: :index, id: 26)}
  it { should route(:put, '/api/v1/auth/shops/26/deliveries').to(controller: 'api/v1/shops/deliveries', action: :update, id: 26)}
end