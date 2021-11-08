require "rails_helper"

RSpec.describe Api::V1::Products::SummariesController do
  describe "POST #search" do
    context "All ok" do
      context "params location" do
        context "is a city" do
          it "should call ::Criterias::InCities and return 200 HTTP status" do
            city = create(:city)

            mocks_searchkick = []
            5.times do
              mocks_searchkick << Searchkick::HashWrapper.new({
                                                                "_index" => "shops_v1_20210315094629392",
                                                                "_type" => "_doc",
                                                                "_id" => "4648",
                                                                "_score" => 0.9988128,
                                                                "name" => "Edessa kebab",
                                                                "created_at" => "2020-05-10T09:07:03.576+02:00",
                                                                "updated_at" => "2020-05-10T09:07:09.498+02:00",
                                                                "slug" => "edessa-kebab",
                                                                "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
                                                                "category_tree_ids" => [2359, 2371],
                                                                "category_tree_names" => ["Restauration",
                                                                                          "Traiteur"],
                                                                "baseline" => "pouet",
                                                                "description" => "pouet",
                                                                "brands_name" => [""],
                                                                "city_label" => "bordeaux",
                                                                "city_slug" => "bordeaux",
                                                                "insee_code" => "72264",
                                                                "territory_name" => "bordeaux",
                                                                "territory_slug" => "bordeaux",
                                                                "department_number" => "72",
                                                                "deleted_at" => "pouet",
                                                                "number_of_online_products" => 3,
                                                                "number_of_orders" => 0,
                                                                "image_url" => "default_box_shop.svg",
                                                                "coupons" => "[]",
                                                                "pictogram_url" => "pouet",
                                                                "services" => ["click-collect",
                                                                              "livraison-express-par-stuart",
                                                                              "livraison-par-la-poste",
                                                                              "livraison-par-colissimo",
                                                                              "e-reservation"],
                                                                "is_template" => false,
                                                                "score" => 0,
                                                                "indexed_at" => "2021-06-28T18:36:54.691+00:00",
                                                                "id" => "4648",
                                                              })
            end

            test_default_criterias

            spy_criteria = spy(::Criterias::InCities)
            expect(::Criterias::InCities).to receive(:new).with(city.insee_codes).and_return(spy_criteria)
            allow(::Requests::ProductSearches.new(
              query: "pouet"
            )).to receive(:call).and_return(mocks_searchkick)
            post :search, params: { location: "pau" }
            should respond_with(200)
          end
        end

        context "is a territory" do
          it "should call ::Criterias::InTerritory and return 200 HTTP status" do
            territory = create(:territory)

            mocks_searchkick = []
            5.times do
              mocks_searchkick << Searchkick::HashWrapper.new({
                                                                "_index" => "shops_v1_20210315094629392",
                                                                "_type" => "_doc",
                                                                "_id" => "4648",
                                                                "_score" => 0.9988128,
                                                                "name" => "Edessa kebab",
                                                                "created_at" => "2020-05-10T09:07:03.576+02:00",
                                                                "updated_at" => "2020-05-10T09:07:09.498+02:00",
                                                                "slug" => "edessa-kebab",
                                                                "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
                                                                "category_tree_ids" => [2359, 2371],
                                                                "category_tree_names" => ["Restauration",
                                                                                          "Traiteur"],
                                                                "baseline" => "pouet",
                                                                "description" => "pouet",
                                                                "brands_name" => [""],
                                                                "city_label" => "bordeaux",
                                                                "city_slug" => "bordeaux",
                                                                "insee_code" => "72264",
                                                                "territory_name" => "bordeaux",
                                                                "territory_slug" => "bordeaux",
                                                                "department_number" => "72",
                                                                "deleted_at" => "pouet",
                                                                "number_of_online_products" => 3,
                                                                "number_of_orders" => 0,
                                                                "image_url" => "default_box_shop.svg",
                                                                "coupons" => "[]",
                                                                "pictogram_url" => "pouet",
                                                                "services" => ["click-collect",
                                                                              "livraison-express-par-stuart",
                                                                              "livraison-par-la-poste",
                                                                              "livraison-par-colissimo",
                                                                              "e-reservation"],
                                                                "is_template" => false,
                                                                "score" => 0,
                                                                "indexed_at" => "2021-06-28T18:36:54.691+00:00",
                                                                "id" => "4648",
                                                              })
            end

            test_default_criterias

            spy_criteria = spy(::Criterias::InTerritory)
            expect(::Criterias::InTerritory).to receive(:new).with(territory.slug).and_return(spy_criteria)
            allow(::Requests::ProductSearches.new(
              query: "pouet"
            )).to receive(:call).and_return(mocks_searchkick)
            post :search, params: { location: "territoire-des-apaches" }
            should respond_with(200)
          end
        end

        context "is empty" do
          it "should call Criterias::InCountry.new() and return 200" do
            mocks_searchkick = []
            5.times do
              mocks_searchkick << Searchkick::HashWrapper.new({
                                                                "_index" => "shops_v1_20210315094629392",
                                                                "_type" => "_doc",
                                                                "_id" => "4648",
                                                                "_score" => 0.9988128,
                                                                "name" => "Edessa kebab",
                                                                "created_at" => "2020-05-10T09:07:03.576+02:00",
                                                                "updated_at" => "2020-05-10T09:07:09.498+02:00",
                                                                "slug" => "edessa-kebab",
                                                                "shop_url" => "/fr/sable-sur-sarthe/boutiques/edessa-kebab",
                                                                "category_tree_ids" => [2359, 2371],
                                                                "category_tree_names" => ["Restauration",
                                                                                          "Traiteur"],
                                                                "baseline" => "pouet",
                                                                "description" => "pouet",
                                                                "brands_name" => [""],
                                                                "city_label" => "bordeaux",
                                                                "city_slug" => "bordeaux",
                                                                "insee_code" => "72264",
                                                                "territory_name" => "bordeaux",
                                                                "territory_slug" => "bordeaux",
                                                                "department_number" => "72",
                                                                "deleted_at" => "pouet",
                                                                "number_of_online_products" => 3,
                                                                "number_of_orders" => 0,
                                                                "image_url" => "default_box_shop.svg",
                                                                "coupons" => "[]",
                                                                "pictogram_url" => "pouet",
                                                                "services" => ["click-collect",
                                                                              "livraison-express-par-stuart",
                                                                              "livraison-par-la-poste",
                                                                              "livraison-par-colissimo",
                                                                              "e-reservation"],
                                                                "is_template" => false,
                                                                "score" => 0,
                                                                "indexed_at" => "2021-06-28T18:36:54.691+00:00",
                                                                "id" => "4648",
                                                              })
            end
            test_default_criterias

            spy_criteria = spy(::Criterias::InCountry)
            expect(::Criterias::InCountry).to receive(:new).with(nil).and_return(spy_criteria)
            allow(::Requests::ProductSearches.new(
              query: "pouet"
            )).to receive(:call).and_return(mocks_searchkick)
            post :search, params: { location: "" }
            should respond_with(200)
          end
        end
      end
    end

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
          location = create(:city)
          post :search, params: { location: location.slug, category: "casque-radio-star-wars" }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Category").to_h.to_json)
        end
      end
    end
  end
end

def test_default_criterias
  spy_online = spy(::Criterias::Products::Online)
  expect(::Criterias::Composite).to receive(:new).with(::Criterias::Products::Online).and_return(spy_online)
  spy_not_in_shop = spy(::Criterias::Products::NotInShopTemplate)
  expect(spy_online).to receive(:and).with(::Criterias::Products::NotInShopTemplate).and_return(spy_not_in_shop)
  spy_not_in_holidays = spy(::Criterias::NotInHolidays)
  expect(spy_not_in_shop).to receive(:and).with(::Criterias::NotInHolidays).and_return(spy_not_in_holidays)
end
