require "rails_helper"

RSpec.describe "routes for selections", :type => :routing do
  it { should route(:post, '/api/v1/auth/selections').to(controller: 'api/v1/selections', action: :create) }
end
