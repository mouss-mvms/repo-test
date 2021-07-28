require 'rails_helper'

RSpec.describe Api::Shops::SchedulesController do

  describe 'GET #index' do
    context 'All ok' do
      it 'should return 200 HTTP Status with schedules of shop' do
        shop = create(:shop)

        get :index, params: { id: shop.id }

        expect(response).to have_http_status(:ok)
        result = JSON.parse(response.body)
        expect(result.count).to eq(shop.schedules.count)
      end
    end

    context 'Shop not found' do
      it 'should return 404 HTTP Status' do
        shop = create(:shop)
        Shop.destroy_all

        get :index, params: { id: shop.id }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{shop.id}").to_h.to_json)
      end
    end
  end

end