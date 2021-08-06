require "rails_helper"

RSpec.describe "routes for Shops", :type => :routing do
  it { should route(:get, '/api/shops/26').to(controller: 'api/shops', action: :show, id: 26) }
  it { should route(:post, '/api/auth/shops').to(controller: 'api/shops', action: :create) }
  it { should route(:put, '/api/auth/shops/26').to(controller: 'api/shops', action: :update, id: 26) }
  it { should route(:get, '/api/shops').to(controller: 'api/shops', action: :index)}
end
