require "rails_helper"

RSpec.describe "routes for images", :type => :routing do
  it { should route(:post, "/api/v1/auth/images").to(controller: "api/v1/images", action: :create) }
  it { should route(:delete, "/api/v1/auth/avatar/images/666").to(controller: "api/v1/images", action: :destroy_avatar, id: 666) }
end
