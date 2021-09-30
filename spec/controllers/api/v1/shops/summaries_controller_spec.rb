require "rails_helper"

RSpec.describe Api::V1::Shops::SummariesController, type: :controller do
  describe "GET #index" do
    context "All ok" do
      context "when location" do
        it 'returns a searchkick result' do
          city = create(:city, slug: 'bordeaux')
          searchkick_result = Searchkick::HashWrapper.new({
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
          allow(::Requests::ShopSearches).to receive(:search_highest_scored_shops).and_return([searchkick_result])
          allow(::Requests::ShopSearches).to receive(:search_random_shops).and_return([searchkick_result])

          get :index, params: { location: city.slug }
          should respond_with(200)
        end
      end

      context "with Fields filtered" do
          it 'should return response with fields asked and filtered' do
            city = create(:city, slug: 'bordeaux')
            searchkick_result = Searchkick::HashWrapper.new({
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
            allow(::Requests::ShopSearches).to receive(:search_highest_scored_shops).and_return([searchkick_result])
            allow(::Requests::ShopSearches).to receive(:search_random_shops).and_return([searchkick_result])

            fields = %w[id name]
            get :index, params: { location: city.slug, fields: fields }
            should respond_with(200)
            result = JSON.parse(response.body)
            expect(result).to be_instance_of(Array)
            result.each do |r|
              expect(r).to be_instance_of(Hash)
              expect(r).to have_key(fields.first)
              expect(r).to have_key(fields.last)
              expect(r).not_to have_key(:slug)
            end
          end
        end

      context "when problems" do
        context "location param is missing" do
          it "it returns a 400 http status" do
            get :index
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: location.').to_h.to_json)
          end
        end

        context "location can't be found" do
          it "it returns a 400 http status" do
            get :index, params: { location: 'Neo Detroit' }
            should respond_with(404)
            expect(response.body).to eq(Dto::Errors::NotFound.new('Location not found.').to_h.to_json)
          end
        end
      end
    end
  end

  describe "POST #search" do
    context "All ok" do
      context "when location" do
        it 'returns a searchkick result' do
          city = create(:city, slug: 'bordeaux')
          highest_shops_options = { page: 1, per_page: 9, padding: 0, load: false, includes: nil, model_includes: nil, json: false, match_suffix: "analyzed", highlight: nil, highlighted_fields: [], misspellings: false, term: "*", scope_results: nil, total_results: nil, index_mapping: nil, suggest: nil, scroll: nil }
          highest_shops_response = {
            "took" => 6,
            "timed_out" => false,
            "_shards" => {
              "total" => 1,
              "successful" => 1,
              "skipped" => 0,
              "failed" => 1,
            },
            "hits" => {
              "total" => {},
              "max_score" => nil,
              "hits" => []
            },
            "aggregations" => {
              "category_tree_ids" => {
                "doc_count" => 0,
                "category_tree_ids" => {
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" => []
                },
                "brands_name" => {
                  "doc_count" => 0,
                  "services" => {
                    "doc_count_error_upper_bound" => 0,
                    "sum_other_doc_count" => 0,
                    "buckets" => []
                  }
                },
                "services" => {
                  "doc_count" => 0,
                  "services" => {
                    "doc_count_error_upper_bound" => 0,
                    "sum_other_doc_count" => 0,
                    "buckets" => []
                  }
                },
              }
            }
          }
          highest_shops = Searchkick::Results.new(Shop, highest_shops_response, highest_shops_options)

          random_shops_options = { page: 1, per_page: 9, padding: 0, load: false, includes: nil, model_includes: nil, json: false, match_suffix: "analyzed", highlight: nil, highlighted_fields: [], misspellings: false, term: "*", scope_results: nil, total_results: nil, index_mapping: nil, suggest: nil, scroll: nil }
          random_shops_response = {
            "took" => 6,
            "timed_out" => false,
            "_shards" => {
              "total" => 1,
              "successful" => 1,
              "skipped" => 0,
              "failed" => 1,
            },
            "hits" => {
              "total" => {
                "value" => 1
                "relation" => "eq"
              },
              "max_score" => nil,
              "hits" => [
                {
                  "_index" => "shops_v1_20210314105410121",
                  "_type" => "_doc",
                  "_id" => "3950",
                  "_score" => nil,
                  "_source" => {},
                  "sort" => [38]
                }
              ]
            },
            "aggregations" => {
              "category_tree_ids" => {
                "doc_count" => 1,
                "category_tree_ids" => {
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" => [
                                {
                                  "key" => 2054,
                                  "doc_count" => 1
                                }]
                },
                "brands_name" => {
                  "doc_count" => 1,
                  "services" => {
                    "doc_count_error_upper_bound" => 0,
                    "sum_other_doc_count" => 0,
                    "buckets" => [
                                  {
                                    "key" => "Ideal Shoes",
                                    "doc_count" => 1
                                  }]
                  }
                },
                "services" => {
                  "doc_count" => 1,
                  "services" => {
                    "doc_count_error_upper_bound" => 0,
                    "sum_other_doc_count" => 0,
                    "buckets" => [{
                                    "key" => "e-reservation",
                                    "doc_count" => 1
                                  }]
                  }
                },
              }
            }
          }
          random_shops = Searchkick::Results.new(Shop, random_shops_response, random_shops_options)

          allow(::Requests::ShopSearches).to receive(:search_highest_scored_shops).and_return(highest_shops)
          allow(::Requests::ShopSearches).to receive(:search_random_shops).and_return(random_shops)

          post :search, params: { location: city.slug }
          should respond_with(200)
          expect(response.body).to eq(Dto::V1::Shop::Search.new({page: 1}))
        end
      end

      context "with Fields filtered" do
        it 'should return response with fields asked and filtered' do
          city = create(:city, slug: 'bordeaux')
          searchkick_result = Searchkick::HashWrapper.new({
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
          allow(::Requests::ShopSearches).to receive(:search_highest_scored_shops).and_return([searchkick_result])
          allow(::Requests::ShopSearches).to receive(:search_random_shops).and_return([searchkick_result])

          fields = %w[id name]
          get :index, params: { location: city.slug, fields: fields }
          should respond_with(200)
          result = JSON.parse(response.body)
          expect(result).to be_instance_of(Array)
          result.each do |r|
            expect(r).to be_instance_of(Hash)
            expect(r).to have_key(fields.first)
            expect(r).to have_key(fields.last)
            expect(r).not_to have_key(:slug)
          end
        end
      end

      context "when problems" do
        context "location param is missing" do
          it "it returns a 400 http status" do
            get :index
            should respond_with(400)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: location.').to_h.to_json)
          end
        end

        context "location can't be found" do
          it "it returns a 400 http status" do
            get :index, params: { location: 'Neo Detroit' }
            should respond_with(404)
            expect(response.body).to eq(Dto::Errors::NotFound.new('Location not found.').to_h.to_json)
          end
        end
      end
    end
  end
end
