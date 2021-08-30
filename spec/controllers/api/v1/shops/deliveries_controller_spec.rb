require 'rails_helper'

RSpec.describe Api::V1::Shops::DeliveriesController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      it 'should return 200 HTTP Status with deliveries for a shop requested' do
        shop = create(:shop)
        delivery1 = create(:service_delivery)
        delivery2 = create(:service_not_delivery)
        shop.services << delivery1
        shop.services << delivery2
        shop.save

        get :index, params: { id: shop.id }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to be_instance_of(Array)
        expect(body.any?).to eq(true)
        expect(body.count).to eq(shop.services.count)
      end
    end
    context "with invalid params" do
      context "shop_id not a Numeric" do
        it "should returns 400 HTTP Status" do
          get :index, params: { id: 'Xenomorph' }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('Shop_id is incorrect').to_h.to_json)
        end
      end

      context "shop doesn't exists" do
        it "should returns 404 HTTP Status" do
          id = 1
          Shop.all.each do |shop|
            break if shop.id != id
            id = id + 1
          end
          get :index, params: { id: id }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{id}").to_h.to_json)
        end
      end
    end
  end
end
