require 'rails_helper'

RSpec.describe Api::Citizens::ProductsController, type: :controller do
  describe 'GET #Show' do
    context 'All ok' do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      it 'should return 200 HTTP Status with product response' do
        citizen.products << product
        citizen.save
        get :show, params: {id: citizen.id, product_id: product.id}

        should respond_with(200)
        expect(response.body).to eq(Dto::Product::Response.create(product).to_h.to_json)
      end
    end

    context 'Citizen not found' do
      let(:product) {create(:product)}

      it 'should return 404 HTTP Status' do
        get :show, params: {id: 0, product_id: product.id}

        should respond_with(404)
      end
    end

    context 'Product not found' do
      let(:citizen) {create(:citizen)}

      it 'should return 404 HTTP Status' do
        get :show, params: {id: citizen.id, product_id: 0}

        should respond_with(404)
      end
    end

    context "Product exists but it's not a citizen's product" do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      it 'should return 404 HTTP Status' do
        get :show, params: {id: citizen.id, product_id: product.id}

        should respond_with(404)
      end
    end
  end
end
