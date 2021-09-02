require "rails_helper"

RSpec.describe "routes for Review", :type => :routing do
  it { should route(:post, '/api/v1/auth/reviews').to(controller: 'api/v1/reviews', action: :create) }
end
