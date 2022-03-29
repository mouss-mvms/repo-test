require 'rails_helper'

RSpec.describe Api::V1::Admin::SelectionsController do
  describe "GET #index" do
    describe "All ok" do
      before :all do
        @admin = create(:admin_user)
        @selections = []
        @selections << create_list(:selection, 10)
        @selections << create_list(:online_selection, 10)
        @selections = @selections.flatten
        @admin_token = generate_token(@admin)
        @default_count_per_page = 16
        @total_pages = 2
        @default_requested_page = 1
      end

      after :all do
        @admin.destroy
        Selection.destroy_all
        Tag.destroy_all
        @admin_token = nil
        @default_count_per_page = nil
        @total_pages = nil
        @default_requested_page = nil
      end
      context "no page params" do
        it "should return page 1 all selections" do
          request.headers['x-client-id'] = @admin_token

          get :index
          expect(response).to have_http_status(200)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body[:selections].count).to eq(@default_count_per_page)
          expect(response_body[:page]).to eq(@default_requested_page)
          expect(response_body[:totalPages]).to eq(@total_pages)
        end
      end

      context "page params present" do
        it "should return page 2 of all selections" do
          request.headers['x-client-id'] = @admin_token
          requested_page = 2

          get :index, params: { page: requested_page }
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:selections].count).to eq(@selections.count - @default_count_per_page)
          expect(response_body[:page]).to eq(requested_page)
          expect(response_body[:totalPages]).to eq(@total_pages)
        end
      end

      context "promoted is true" do
        it "should return only promoted selections" do
          request.headers['x-client-id'] = @admin_token
          @selections.last.update(featured: true)

          get :index, params: { promoted: true }
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:selections].count).to eq(@selections.count {|s| s.featured == true})
          expect(response_body[:page]).to eq(@default_requested_page)
          expect(response_body[:totalPages]).to eq(1)
        end
      end

      context "promoted is false" do
        it "should return only promoted selections" do
          request.headers['x-client-id'] = @admin_token
          get :index, params: { promoted: false }
          response_body = JSON.parse(response.body, symbolize_names: true)

          expect(response_body[:selections].count).to eq(@selections.first(@default_count_per_page).count {|s| s.featured == false})
          expect(response_body[:page]).to eq(@default_requested_page)
          expect(response_body[:totalPages]).to eq(@total_pages)
        end
      end
    end

    describe "Bad Authentication" do
      context "no x-client-id" do
        it "should return 401 HTTP status" do
          get :index
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "user doesn't exist" do
        it "should return 403 HTTP status" do
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)
          User.destroy_all

          get :index
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "user is not an admin" do
        it "should return 403 HTTP status" do
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)

          get :index
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
          user.destroy
        end
      end
    end
  end

  describe "GET #show" do
    describe "All ok" do
      context "Selection is online" do
        it "returns a selection dto and 200 HTTP status" do
          admin = create(:admin_user)
          selection = create(:online_selection)
          request.headers['x-client-id'] = generate_token(admin)

          get :show, params: { id: selection.id }
          should respond_with(200)
          expect(response.body).to eq(Dto::V1::Selection::Response.create(selection).to_h.to_json)
        end
      end

      context "Selection is offline" do
        it "returns a selection dto and 200 HTTP status" do
          admin = create(:admin_user)
          selection = create(:selection)
          request.headers['x-client-id'] = generate_token(admin)

          get :show, params: { id: selection.id }
          should respond_with(200)
          expect(response.body).to eq(Dto::V1::Selection::Response.create(selection).to_h.to_json)
        end
      end
    end

    describe "Bad params" do
      context "Selection does not exist" do
        it "should returns 404 HTTP status" do
          admin = create(:admin_user)
          request.headers['x-client-id'] = generate_token(admin)

          get :show, params: { id: 44 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=44").to_h.to_json)
        end
      end
    end

    describe "Bad Authentication" do
      context "no x-client-id" do
        it "should return 401 HTTP status" do
          get :show, params: { id: 44 }
          should respond_with(401)
          expect(response.body).to eq(Dto::Errors::Unauthorized.new.to_h.to_json)
        end
      end

      context "user doesn't exist" do
        it "should return 403 HTTP status" do
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)
          User.destroy_all

          get :show, params: { id: 44 }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end

      context "user is not an admin" do
        it "should return 403 HTTP status" do
          user = create(:user)
          request.headers['x-client-id'] = generate_token(user)

          get :show, params: { id: 44 }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
