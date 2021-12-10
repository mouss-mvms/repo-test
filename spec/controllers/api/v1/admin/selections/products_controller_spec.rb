require 'rails_helper'

RSpec.describe Api::V1::Admin::Selections::ProductsController do
  describe "GET #index" do
    context "All ok" do
      context "No page in query" do
        it "should return 200 HTTP status with page 1 of selection products (16 per page)" do
          admin = create(:admin_user)
          selection = create(:online_selection)
          request.headers['x-client-id'] = generate_token(admin)
          17.times do
            selection.products << create(:available_product)
          end

          get :index, params: { id: selection.id }
          should respond_with(200)
          expect(response.body).to eq(
            {
              products: selection.products.first(16).map { |p| Dto::V1::Product::Response.create(p).to_h },
              page: 1,
              totalPages: 2
            }.to_json
          )
        end
      end

      context "With page number in query" do
        it "should return 200 HTTP status with page 2 of selection products" do
          admin = create(:admin_user)
          selection = create(:online_selection)
          request.headers['x-client-id'] = generate_token(admin)
          17.times do
            selection.products << create(:available_product)
          end

          get :index, params: { id: selection.id, page: 2 }
          should respond_with(200)
          expect(response.body).to eq(
            {
              products: selection.products.last(2).map { |p| Dto::V1::Product::Response.create(p).to_h },
              page: 2,
              totalPages: 2
            }.to_json
          )
        end
      end
    end

    describe "Bad Authentication" do
      context "no x-client-id" do
        it "should return 401 HTTP status" do
          selection = create(:selection)
          get :index, params: { id: selection.id }
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "user doesn't exist" do
        it "should return 403 HTTP status" do
          selection = create(:selection)
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)
          User.destroy_all

          get :index, params: { id: selection.id }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "user is not an admin" do
        it "should return 403 HTTP status" do
          selection = create(:selection)
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)

          get :index, params: { id: selection.id }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end

    context 'Bad params' do
      context "Selection does not exist" do
        it "should return 404 HTTP status" do
          admin = create(:admin_user)
          request.headers['x-client-id'] = generate_token(admin)
          get :index, params: { id: 666 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=666").to_h.to_json)
        end
      end
    end
  end
end