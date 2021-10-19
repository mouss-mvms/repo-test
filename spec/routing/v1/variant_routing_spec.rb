require "rails_helper"

RSpec.describe "routes for Variants", :type => :routing do
  it { should route(:patch, '/api/v1/auth/variants/42').to(controller: 'api/v1/variants', action: :update, id: 42) }
end