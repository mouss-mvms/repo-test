require 'rails_helper'

RSpec.describe Api::ShopsController, type: :controller do
  describe "GET #show" do
    context "All ok" do
      it 'should return shop information' do
        shop = create(:shop)
        shop.address.addressable = shop
        shop.save

        get :show, params: {id: shop.id}

        expect(response).to have_http_status(200)
        expect(response.body).to eq(Dto::Shop::Response.create(shop).to_h.to_json)
      end
    end

    context "Shop id is 0" do
      it 'should return 400 HTTP Status' do
        shop = create(:shop)

        get :show, params: {id: 0}

        expect(response).to have_http_status(400)
      end
    end

    context "Shop id is not numeric" do
      it 'should return 400 HTTP Status' do
        shop = create(:shop)

        get :show, params: {id: "jjei"}

        expect(response).to have_http_status(400)
      end
    end

    context "Shop doesn't exist" do
      before(:each) do
        Shop.destroy_all
      end
      it 'should return 404 HTTP Status' do
        get :show, params: {id: 200}

        expect(response).to have_http_status(404)
      end
    end
  end
end
