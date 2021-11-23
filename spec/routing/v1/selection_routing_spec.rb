require "rails_helper"

RSpec.describe "routes for selections", :type => :routing do
  it { should route(:post, '/api/v1/auth/selections').to(controller: 'api/v1/selections', action: :create) }
  it { should route(:patch, '/api/v1/auth/selections/42').to(controller: 'api/v1/selections', action: :patch, id: 42) }
end
