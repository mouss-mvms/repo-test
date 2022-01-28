require 'rails_helper'

RSpec.describe Api::V1::Tags::ProductsController do
  describe "GET #index" do
    context "All ok" do
      it 'should return 200 HTTP status with products of tag' do
        tag = create(:tag)
        count = 10
        count.times do
          tag.products << create(:available_product)
        end
        15.times do
          create(:product)
        end

        get :index, params: { id: tag.id }

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body).deep_symbolize_keys
        expect(result[:products].count).to eq(count)
        result[:products].each do |result_product|
          expect_product = Product.find(result_product[:id])
          expect(result_product).to eq(Dto::V1::Product::Response.create(expect_product).to_h)
        end
      end
    end
  end
end