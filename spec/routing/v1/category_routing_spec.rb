require "rails_helper"

RSpec.describe "routes for Categories", :type => :routing do
  it { should route(:get, '/api/v1/categories').to(controller: 'api/v1/categories', action: :index) }
end
