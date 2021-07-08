require "rails_helper"

RSpec.describe "routes for Citizens", :type => :routing do
  it { should route(:get, '/api/citizens/56/products/4553').to(controller: 'api/citizens/products', action: :show, id: 56, product_id: 4553) }
end
