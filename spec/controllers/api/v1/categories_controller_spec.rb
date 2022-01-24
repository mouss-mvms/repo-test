require "rails_helper"

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe "GET #roots" do
    context "All ok" do
      before(:all) do
        @category_1 = create(:category, name: "Category 1")
        @category_2 = create(:category, name: "Category 2")
        @category_3 = create(:category, name: "Category 3")
        @subcategory_1 = create(:category, name: "subcategory 1", parent_id: @category_1.id)
        @subcategory_2 = create(:category, name: "subcategory 2", parent_id: @category_2.id)
        @subcategory_3 = create(:category, name: "subcategory 2", parent_id: @subcategory_2.id)
      end
      after(:all) do
        @subcategory_1.destroy
        @subcategory_2.destroy
        @subcategory_3.destroy
        @category_1.destroy
        @category_2.destroy
        @category_3.destroy
      end

      context "when no params children" do
        it "should respond HTTP Status 200 with all parents category without children" do
          get :roots
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          categories = Category.where(parent_id: nil).map { |category| Dto::V1::Category::Response.create(category).to_h }
          expect(response_body).to eq(categories)
          response_body.each do |category|
            expect(category.key?(:children)).to eq(false)
          end
        end
      end

      context "when params children" do
        it "should respond HTTP Status 200 with all parents category without they children" do
          get :roots, params: { children: "true" }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          categories = Category.where(parent_id: nil).map { |category| Dto::V1::Category::Response.create(category).to_h({ children: true }) }
          expect(response_body).to eq(categories)
        end
      end

      context "when etag is present" do
        it "should respond with HTTP status 304" do
          get :roots
          should respond_with(200)
          etag = response.headers["ETag"]
          request.env["HTTP_IF_NONE_MATCH"] = etag
          get :roots
          should respond_with(304)
        end
      end
    end

    context "When problems" do
      context "when children params has invalid value" do
        it "should return http status 400 with message" do
          get :roots, params: { children: "yes" }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('children must be true or false.').to_h.to_json)
        end
      end
    end
  end

  describe "GET #show" do
    before(:all) do
      @category_1 = create(:category, name: "Category 1")
      @category_2 = create(:category, name: "Category 2")
      @category_3 = create(:category, name: "Category 3")
      @subcategory_1 = create(:category, name: "subcategory 1", parent_id: @category_1.id)
      @subcategory_2 = create(:category, name: "subcategory 2", parent_id: @category_2.id)
      @subcategory_3 = create(:category, name: "subcategory 2", parent_id: @subcategory_2.id)
    end
    after(:all) do
      @subcategory_1.destroy
      @subcategory_2.destroy
      @subcategory_3.destroy
      @category_1.destroy
      @category_2.destroy
      @category_3.destroy
    end
    context "All ok" do
      context "when no params children" do
        it "should respond HTTP Status 200 with desire category without children" do
          get :show, params: { id: @category_1.id }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          category = Dto::V1::Category::Response.create(@category_1).to_h
          expect(response_body).to eq(category)
          expect(category.key?(:children)).to eq(false)
        end
      end

      context "when params children" do
        it "should respond HTTP Status 200 with desire category with children" do
          get :show, params: { id: @category_1.id, children: true }
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body, symbolize_names: true)
          category = Dto::V1::Category::Response.create(@category_1).to_h({ children: true })
          expect(response_body).to eq(category)
        end
      end

      context "when etag is present" do
        it "should respond with HTTP status 304" do
          get :show, params: { id: @category_1.id }
          should respond_with(200)
          etag = response.headers["ETag"]
          request.env["HTTP_IF_NONE_MATCH"] = etag
          get :show, params: { id: @category_1.id }
          should respond_with(304)
        end
      end
    end

    context "When problems" do
      context "when category doesn't not exist" do
        it "should return http status 404 with message" do
          @category_0 = create(:category, name: "Category 0")
          deleted_category_id = @category_0.id
          @category_0.destroy
          get :show, params: { id: deleted_category_id }
          should respond_with(404)
        end
      end

      context "when children params has invalid value" do
        it "should return http status 400 with message" do
          get :show, params: { id: @category_1.id, children: "yes" }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new('children must be true or false.').to_h.to_json)
        end
      end
    end
  end
end