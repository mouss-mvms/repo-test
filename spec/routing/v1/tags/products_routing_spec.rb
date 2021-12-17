require "rails_helper"

RSpec.describe "routes for tags", :type => :routing do
  it { should route(:get, '/api/v1/tags/45/products').to(controller: 'api/v1/tags/products', action: :index, id: 45) }
end
