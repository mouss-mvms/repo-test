require 'rails_helper'

RSpec.describe Api::V1::Shops::DeliveriesController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      before(:each) do
        @shop = create(:shop)
        delivery1 = create(:service_delivery, disabled: false)
        delivery2 = create(:service_not_delivery, disabled: false)
        @shop.services << delivery1
        @shop.services << delivery2
        @shop.delivery_options
        @shop.save
      end
      it 'should return 200 HTTP Status with deliveries for a shop requested' do
        get :index, params: { id: @shop.id }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to be_instance_of(Array)
        expect(body.any?).to eq(true)
        expect(body.count).to eq(@shop.services.count)
      end

      it 'should return 200 HTTP Status with deliveries for a shop requested' do
        get :index, params: { id: @shop.id }
        expect(response).to have_http_status(:ok)

        etag = response.headers["ETag"]
        request.env["HTTP_IF_NONE_MATCH"] = etag
        get :index, params: { id: @shop.id }
        expect(response).to have_http_status(304)
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

  describe "PUT #update" do
    context "All ok" do
      context "with freeDeliveryPrice" do
        it "should update shop deliveries" do
          shop = create(:shop, is_self_delivery: false)
          user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
          shop.owner = user.shop_employee
          colissimo = create(:service_delivery, name: "livraison par colissimo", shop_dependent: false, disabled: false)
          click_collect = create(:service_not_delivery, name: "click collect", shop_dependent: true, disabled: false)
          self_delivery = create(:service_delivery, name: "livraison par le commerçant", shop_dependent: true, disabled: false)

          shop.services << click_collect
          shop.services << colissimo
          shop.services << self_delivery
          shop.delivery_options.where(service_id: [click_collect.id, self_delivery.id]).update_all(is_enabled: false)
          shop.save!
          request.headers['x-client-id'] = generate_token(user)

          params = {
            id: shop.id,
            serviceSlugs: [
              click_collect.slug,
              self_delivery.slug
            ],
            selfDeliveryPrice: 1.55,
            freeDeliveryPrice: 45
          }

          expect(shop.is_self_delivery).to be(false)
          expect(shop.active_services.count).to eq(1)
          expect(shop.active_services).to include(colissimo)
          expect(shop.free_delivery_price).to be_nil
          expect(shop.self_delivery_price).to be_nil

          put :update, params: params

          should respond_with(200)
          expected_response = [Dto::V1::Delivery::Response.create(click_collect).to_h, Dto::V1::Delivery::Response.create(self_delivery).to_h].to_json
          expect(response.body).to eq(expected_response)

          shop.reload
          expect(shop.active_services.count).to eq(2)
          expect(shop.active_services).to include(click_collect)
          expect(shop.active_services).to include(self_delivery)
          expect(shop.is_self_delivery).to be(true)
          expect(shop.active_services).not_to include(colissimo)
          expect(shop.free_delivery_price).to eq(params[:freeDeliveryPrice])
          expect(shop.self_delivery_price).to eq(params[:selfDeliveryPrice])
        end
      end

      context "without freeDeliveryPrice" do
        it "should update shop deliveries" do
          shop = create(:shop, is_self_delivery: false)
          user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
          shop.owner = user.shop_employee
          colissimo = create(:service_delivery, name: "livraison par colissimo", shop_dependent: false, disabled: false)
          click_collect = create(:service_not_delivery, name: "click collect", shop_dependent: true, disabled: false)
          self_delivery = create(:service_delivery, name: "livraison par le commerçant", shop_dependent: true, disabled: false)

          shop.services << click_collect
          shop.services << colissimo
          shop.services << self_delivery
          shop.delivery_options.where(service_id: [click_collect.id, self_delivery.id]).update_all(is_enabled: false)
          shop.save!
          request.headers['x-client-id'] = generate_token(user)

          params = {
            id: shop.id,
            serviceSlugs: [
              click_collect.slug,
              self_delivery.slug
            ],
            selfDeliveryPrice: 1.55
          }

          expect(shop.is_self_delivery).to be(false)
          expect(shop.active_services.count).to eq(1)
          expect(shop.active_services).to include(colissimo)
          expect(shop.free_delivery_price).to be_nil
          expect(shop.self_delivery_price).to be_nil

          put :update, params: params

          should respond_with(200)
          expected_response = [Dto::V1::Delivery::Response.create(click_collect).to_h, Dto::V1::Delivery::Response.create(self_delivery).to_h].to_json
          expect(response.body).to eq(expected_response)

          shop.reload
          expect(shop.active_services.count).to eq(2)
          expect(shop.active_services).to include(click_collect)
          expect(shop.active_services).to include(self_delivery)
          expect(shop.is_self_delivery).to be(true)
          expect(shop.active_services).not_to include(colissimo)
          expect(shop.free_delivery_price).to eq(params[:freeDeliveryPrice])
          expect(shop.self_delivery_price).to eq(params[:selfDeliveryPrice])
        end
      end

      context "request removes livraison-par-le-commerçant" do
        it "reset shop free_delivery_price attributes" do
          shop = create(:shop, is_self_delivery: false)
          user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
          shop.owner = user.shop_employee
          colissimo = create(:service_delivery, name: "livraison par colissimo", shop_dependent: false, disabled: false)
          click_collect = create(:service_not_delivery, name: "click collect", shop_dependent: true, disabled: false)
          self_delivery = create(:service_delivery, name: "livraison par le commerçant", shop_dependent: true, disabled: false)

          shop.services << click_collect
          shop.services << colissimo
          shop.services << self_delivery
          shop.delivery_options.where(service_id: [colissimo.id, click_collect.id]).update_all(is_enabled: false)
          shop.free_delivery_price = 45
          shop.self_delivery_price = 2.55
          shop.is_self_delivery = true
          shop.save!
          request.headers['x-client-id'] = generate_token(user)

          params = {
            id: shop.id,
            serviceSlugs: [
              click_collect.slug,
              colissimo.slug
            ]
          }

          expect(shop.is_self_delivery).to be(true)
          expect(shop.active_services.count).to eq(1)
          expect(shop.active_services).to include(self_delivery)
          expect(shop.free_delivery_price).to eq(45)
          expect(shop.self_delivery_price).to eq(2.55)

          put :update, params: params

          should respond_with(200)
          expected_response = [Dto::V1::Delivery::Response.create(colissimo).to_h, Dto::V1::Delivery::Response.create(click_collect).to_h].to_json
          expect(response.body).to eq(expected_response)

          shop.reload
          expect(shop.active_services.count).to eq(2)
          expect(shop.active_services).to include(click_collect)
          expect(shop.active_services).to include(colissimo)
          expect(shop.is_self_delivery).to be(false)
          expect(shop.active_services).not_to include(self_delivery)
          expect(shop.free_delivery_price).to be_nil
          expect(shop.self_delivery_price).to eq(2.55)
        end
      end
    end

    context "with invalid params" do
      context "shop_id not a Numeric" do
        it "should returns 400 HTTP Status" do
          put :update, params: { id: 'Xenomorph' }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('Shop_id is incorrect').to_h.to_json)
        end
      end

      context "X-client-id is missing" do
        it "should returns 401 HTTP status" do
          shop = create(:shop)

          put :update, params: { id: shop.id }
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "x-client-id doesn't match shop user" do
        it "should return 403 HTTP status" do
          shop = create(:shop)
          user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
          shop.owner = user.shop_employee
          shop.save!
          cheater_user = create(:user)

          request.headers['x-client-id'] = generate_token(cheater_user)

          put :update, params: { id: shop.id }
          should respond_with(403)
        end
      end

      context "shop doesn't exists" do
        it "should returns 404 HTTP Status" do
          id = 1
          Shop.all.each do |shop|
            break if shop.id != id
            id = id + 1
          end
          put :update, params: { id: id }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{id}").to_h.to_json)
        end
      end

      context "serviceSlugs contains 'livraison-par-le-commerçant'" do
        context "freeDeliveryPrice value is < 1.0" do
          it "should returns 4OO HTTP Status" do
            shop = create(:shop)
            user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
            shop.owner = user.shop_employee
            shop.save!
            request.headers['x-client-id'] = generate_token(user)

            params = {
              id: shop.id,
              serviceSlugs: [
                "click-collect",
                "livraison-par-le-commercant"
              ],
              selfDeliveryPrice: 45.99,
              freeDeliveryPrice: 0
            }

            put :update, params: params
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("freeDeliveryPrice must be at least 1.0").to_h.to_json)
          end
        end

        context "selfDeliveryPrice is missing" do
          it "should returns 4OO HTTP Status" do
            shop = create(:shop)
            user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
            shop.owner = user.shop_employee
            shop.save!
            request.headers['x-client-id'] = generate_token(user)

            params = {
              id: shop.id,
              serviceSlugs: [
                "click-collect",
                "livraison-par-le-commercant"
              ],
              freeDeliveryPrice: 45.99,
            }

            put :update, params: params
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: selfDeliveryPrice").to_h.to_json)
          end
        end

        context "selfDeliveryPrice value is 0" do
          it "should return 400 HTTP status" do
            shop = create(:shop)
            user = create(:shop_employee_user, email: 'chucknoris@mvms.fr')
            shop.owner = user.shop_employee
            shop.save!
            request.headers['x-client-id'] = generate_token(user)

            params = {
              id: shop.id,
              serviceSlugs: [
                "click-collect",
                "livraison-par-le-commercant"
              ],
              freeDeliveryPrice: 45.99,
              selfDeliveryPrice: 0
            }

            put :update, params: params
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("selfDeliveryPrice must be non null").to_h.to_json)
          end
        end
      end
    end
  end
end
