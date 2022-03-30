require "rails_helper"

RSpec.describe Api::V1::Products::SummariesController do
  describe "POST #search" do

    context "bad params" do
      context "when city or territory does not exist" do
        it "should return HTTP status NotFound - 404" do
          post :search, params: { location: "bagdad" }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Location not found").to_h.to_json)
        end
      end

      context "when category doesn't exist" do
        it "should return HTTP status NotFound - 404" do
          location = create(:old_city_factory)
          post :search, params: { location: location.slug, category: "casque-radio-star-wars" }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Category").to_h.to_json)
        end
      end
    end
  end
end