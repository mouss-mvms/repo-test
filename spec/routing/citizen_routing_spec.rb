require "rails_helper"

RSpec.describe "routes for Citizens", :type => :routing do
  it { should route(:get, '/api/citizens/56/products').to(controller: 'api/citizens/products', action: :index, id: 56) }
end
