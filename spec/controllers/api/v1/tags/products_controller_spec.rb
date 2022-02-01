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
        result = JSON.parse(response.body, symbolize_names: true)
        expect(result[:products].count).to eq(count)
      end
    end
  end
end