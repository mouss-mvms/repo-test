require "rails_helper"

RSpec.describe "routes for Shops", :type => :routing do
  it { should route(:get, '/api/v1/shops/26').to(controller: 'api/v1/shops', action: :show, id: 26) }
  it { should route(:post, '/api/v1/auth/shops').to(controller: 'api/v1/shops', action: :create) }
  it { should route(:put, '/api/v1/auth/shops/26').to(controller: 'api/v1/shops', action: :update, id: 26) }
  it { should route(:get, '/api/v1/shops/26/deliveries').to(controller: 'api/v1/shops/deliveries', action: :index, id: 26)}
  it { should route(:post, '/api/v1/shops/summaries/search').to(controller: 'api/v1/shops/summaries', action: :search)}
  it { should route(:patch, '/api/v1/auth/shops/45').to(controller: 'api/v1/shops', action: :patch, id: 45)}
end
