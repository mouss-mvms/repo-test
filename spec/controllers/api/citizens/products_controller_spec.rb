require 'rails_helper'

RSpec.describe Api::Citizens::ProductsController, type: :controller do
  describe 'GET #show' do
    context 'All ok' do
      let(:citizen) {create(:citizen)}
      let(:product) {create(:product)}

      it 'should return 200 HTTP Status with product response' do
        citizen.products << product
        citizen.save
        get :show, params: {id: citizen.id, product_id: product.id}

        should respond_with(200)
        product_result = JSON.parse(response.body)
        expect(product_result['id']).to eq(product.id)
        expect(product_result['name']).to eq(product.name)
        expect(product_result['brand']).to eq(product.brand)
        expect(product_result['status']).to eq(product.status)
        expect(product_result['sellerAdvice']).to eq(product.pro_advice)
        expect(product_result['description']).to eq(product.description)
        expect(product_result['citizenAdvice']).to eq(product.advice&.content)
      end
    end

    context 'Citizen not found' do
      let(:product) {create(:product)}

      it 'should return 404 HTTP Status' do
        Citizen.destroy_all
        get :show, params: {id: 34, product_id: product.id}

        should respond_with(404)
      end
    end

    context 'Product not found' do
      let(:citizen) {create(:citizen)}

      it 'should return 404 HTTP Status' do
        Product.destroy_all
        get :show, params: {id: citizen.id, product_id: 88}

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

def generate_token(user)
  exp_payload = { id: user.id, exp: Time.now.to_i + 1 * 3600 * 24 }
  JWT.encode exp_payload, ENV["JWT_SECRET"], 'HS256'
end
