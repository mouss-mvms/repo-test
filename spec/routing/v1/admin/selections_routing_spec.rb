require "rails_helper"

RSpec.describe "admin routes for selections", :type => :routing do
  it { should route(:get, '/api/v1/auth/admin/selections').to(controller: 'api/v1/admin/selections', action: :index) }
  it { should route(:get, '/api/v1/auth/admin/selections/666').to(controller: 'api/v1/admin/selections', action: :show, id: 666) }
  it { should route(:get, '/api/v1/auth/admin/selections/666/products').to(controller: 'api/v1/admin/selections/products', action: :index, id: 666) }
end