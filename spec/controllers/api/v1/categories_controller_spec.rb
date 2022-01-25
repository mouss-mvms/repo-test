require "rails_helper"

RSpec.describe Api::V1::CategoriesController, type: :controller do
  describe "GET #roots" do
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
    end
    after(:all) do
      @category_1.destroy
    end

    context "When problems" do
      context "when category doesn't not exist" do
        it "should return http status 404 with message" do
          searchkick_categories = Searchkick::Results.new(
            Category,
            { "hits" => { "total" => { "value" => 0, "relation" => "eq" }, "max_score" => nil, "hits" => [] } },
            {}
          )
          allow(::Category).to receive(:search).and_return(searchkick_categories)
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