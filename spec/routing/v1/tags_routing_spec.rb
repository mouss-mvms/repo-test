require "rails_helper"

RSpec.describe "routes for Tags", :type => :routing do
  it { should route(:get, '/api/v1/tags').to(controller: 'api/v1/tags', action: :index) }
  it { should route(:get, '/api/v1/tags/26').to(controller: 'api/v1/tags', action: :show, id: 26) }
end

