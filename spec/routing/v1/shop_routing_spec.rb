require "rails_helper"

RSpec.describe "routes for Shops", :type => :routing do
  it { should route(:get, '/api/v1/shops/26').to(controller: 'api/v1/shops', action: :show, id: 26) }
  it { should route(:post, '/api/v1/auth/shops').to(controller: 'api/v1/shops', action: :create) }
  it { should route(:put, '/api/v1/auth/shops/26').to(controller: 'api/v1/shops', action: :update, id: 26) }
  it { should route(:get, '/api/v1/shops').to(controller: 'api/v1/shops', action: :index)}
end
