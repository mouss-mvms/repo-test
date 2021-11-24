require 'rails_helper'

RSpec.describe Api::V1::Selections::ProductsController do
  describe "GET #index" do
    context "All ok" do
      it "should return 200 HTTP status with a selection dto and all of its products" do
        selection = create(:online_selection)

        get :index, params: { id: selection.id }
        should respond_with(200)
        expect(response.body).to eq(
          {
            selection: Dto::V1::Selection::Response.create(selection).to_h,
            products: selection.products.map { |p| Dto::V1::Product::Response.create(p).to_h }
          }.to_json
        )
      end
    end

    context 'Bad params' do
      context "Selection does not exist" do
        it "should return 404 HTTP status" do
          get :index, params: { id: 666 }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Selection with 'id'=666").to_h.to_json)
        end
      end

      context "selection is not online" do
        it "should return a 403 HTTP status" do
          selection = create(:selection)
          get :index, params: { id: selection.id }
          should respond_with(403)
          expect(response.body).to eq(Dto::Errors::Forbidden.new.to_h.to_json)
        end
      end
    end
  end
end
