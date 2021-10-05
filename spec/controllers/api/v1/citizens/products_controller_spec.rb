require 'rails_helper'

RSpec.describe Api::V1::Citizens::ProductsController, type: :controller do
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
        end
      end

      context "citizen doesn't exists" do
        it "should returns 404 HTTP Status" do
          User.where.not(citizen_id: nil).each do |user|
            user.citizen_id = nil
            user.save
          end
          Citizen.delete_all
          get :index, params: { id: 1 }
          should respond_with(404)
        end
      end
    end
  end
end
