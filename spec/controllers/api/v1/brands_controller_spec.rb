require "rails_helper"

RSpec.describe Api::V1::BrandsController, type: :controller do
  describe "POST #create" do
    context "All ok" do
      context "user is a shop_employee" do
        it "should create a brand" do
          params = { name: 'Chuck Noris' }
          request.headers['x-client-id'] = generate_token(create(:shop_employee_user))

          Brand.destroy_all
          expect(Brand.count).to eq(0)

          post :create, params: params
          should respond_with(201)
          expect(Brand.count).to eq(1)
          expect(response.body).to eq(Dto::V1::Brand::Response.create(brand: Brand.first).to_h.to_json)
        end
      end

      context "user is an admin" do
        it "should create a brand" do
          params = { name: 'Chuck Noris' }
          request.headers['x-client-id'] = generate_token(create(:admin_user))

          Brand.destroy_all
          expect(Brand.count).to eq(0)

          post :create, params: params
          should respond_with(201)
          expect(Brand.count).to eq(1)
          expect(response.body).to eq(Dto::V1::Brand::Response.create(brand: Brand.first).to_h.to_json)
        end
      end
    end

    context "When problems" do
      context "params are missing" do
        it "should return 400 HTTP status" do
          request.headers['x-client-id'] = generate_token(create(:shop_employee_user))
          post :create
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: name').to_h.to_json)
        end

        context "x-client-id is missing" do
          it "should return 401 HTTP status" do
            post :create, params: { name: 'DeLorean Motor Company' }
            should respond_with(401)
          end
        end

        context "user is not a shop_employee" do
          it "should return 403 HTTP status" do
            user = create(:user)
            request.headers['x-client-id'] = generate_token(user)

            post :create, params: { name: 'Winchester' }
            should respond_with(403)
          end
        end

        context "user does not exist" do
          it "should return 403 HTTP status" do
            user = create(:user)
            request.headers['x-client-id'] = generate_token(user)

            User.destroy_all

            post :create, params: { name: 'Winchester' }
            should respond_with(403)
          end
        end
      end
    end
  end
end