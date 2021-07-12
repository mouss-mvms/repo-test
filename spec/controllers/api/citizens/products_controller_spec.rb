require 'rails_helper'

RSpec.describe Api::Citizens::ProductsController, type: :controller do
  describe 'GET #index' do
    context 'All ok' do
      let(:citizen) {create(:citizen)}
      let(:products) {create_list(:product, 5)}

      it 'should return 200 HTTP status' do
        citizen.products << products
        citizen.save
        get :index, params: { id: citizen.id }
        expect(response).to have_http_status(:ok)

        response_body = JSON.parse(response.body)
        expect(response_body).to be_an_instance_of(Array)
        expect(response_body.count).to eq(5)

        product_ids = response_body.map { |p| p.symbolize_keys[:id] }
        expect(Product.where(id: product_ids).actives.to_a).to eq(products)
      end
    end

    context "with invalid params" do
      context "id not a Numeric" do
        it "should returns 400 HTTP Status" do
          get :index, params: { id: 'Xenomorph' }
          should respond_with(400)
          expect(JSON.parse(response.body)).to eq({"detail"=>"Shop_id is incorrect", "message"=>"Bad Request", "status"=>400})
        end
      end

      context "citiyzen doesn't exists" do
        it "should returns 404 HTTP Status" do
          Citizen.destroy_all
          get :index, params: { id: 1 }
          should respond_with(404)
        end
      end
    end
  end
end

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], 'HS256'
end
