require "rails_helper"

RSpec.describe "routes for selections", :type => :routing do
  it { should route(:post, '/api/v1/auth/selections').to(controller: 'api/v1/selections', action: :create) }
  it { should route(:get, '/api/v1/selections').to(controller: 'api/v1/selections', action: :index) }
  it { should route(:get, '/api/v1/selections/42').to(controller: 'api/v1/selections', action: :show, id: 42) }
  it { should route(:get, '/api/v1/selections/42/products').to(controller: 'api/v1/selections/products', action: :index, id: 42) }
end
