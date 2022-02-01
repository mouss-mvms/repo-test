require "rails_helper"

RSpec.describe "routes for Categories", :type => :routing do
  it { should route(:get, '/api/v1/categories/roots').to(controller: 'api/v1/categories', action: :roots) }
  it { should route(:get, '/api/v1/categories/12').to(controller: 'api/v1/categories', action: :show, id: 12) }
end
