require "rails_helper"

RSpec.describe "routes for Schedules", :type => :routing do
  it { should route(:get, '/api/shops/24/schedules').to(controller: 'api/shops/schedules', action: :index, id: 24) }
  it { should route(:put, '/api/auth/shops/24/schedules').to(controller: 'api/shops/schedules', action: :update, id: 24) }
end
