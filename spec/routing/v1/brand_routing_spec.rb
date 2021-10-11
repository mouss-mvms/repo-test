require "rails_helper"

RSpec.describe "routes for Brands", :type => :routing do
  it { should route(:post, '/api/v1/auth/brands').to(controller: 'api/v1/brands', action: :create) }
end
