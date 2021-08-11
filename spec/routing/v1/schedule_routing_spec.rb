require "rails_helper"

RSpec.describe "routes for Schedules", :type => :routing do
  it { should route(:get, '/api/v1/shops/24/schedules').to(controller: 'api/v1/shops/schedules', action: :index, id: 24) }
  it { should route(:put, '/api/v1/auth/shops/24/schedules').to(controller: 'api/v1/shops/schedules', action: :update, id: 24) }
end
