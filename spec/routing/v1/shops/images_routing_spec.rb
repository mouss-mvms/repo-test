require "rails_helper"

RSpec.describe "routes for Images' Shop", :type => :routing do
  it { should route(:delete, '/api/v1/auth/shops/self/images/25').to(controller: 'api/v1/shops/images', action: :destroy, id: 25)}
end

