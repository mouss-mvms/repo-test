require "rails_helper"

RSpec.describe "routes for Shops", :type => :routing do
  it { should route(:get, '/api/shops/26').to(controller: 'api/shops', action: :show, id: 26) }
end
