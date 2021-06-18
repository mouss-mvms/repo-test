require "rails_helper"

RSpec.describe "routes for Categories", :type => :routing do
  it { should route(:get, '/api/categories').to(controller: 'api/categories', action: :index) }
end
