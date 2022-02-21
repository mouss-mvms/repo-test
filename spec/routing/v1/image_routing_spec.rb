require "rails_helper"

RSpec.describe "routes for images", :type => :routing do
  it { should route(:post, "/api/v1/auth/images").to(controller: "api/v1/images", action: :create) }
end
