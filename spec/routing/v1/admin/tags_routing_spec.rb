require "rails_helper"

RSpec.describe "admin routes for selections", :type => :routing do
  it { should route(:post, '/api/v1/auth/admin/tags').to(controller: 'api/v1/admin/tags', action: :create) }
end