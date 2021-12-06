require "rails_helper"

RSpec.describe Api::V1::Shops::SummariesController, type: :controller do
  describe "POST #search" do
    context 'Params incorrect' do
      context 'Location' do
        context 'Territory and city does not exist' do
          it 'should return 400 HTTP Status' do
            post :search, params: { location: 'petaouchnok' }

            expect(response).to have_http_status(:not_found)
            expect(response.body).to eq(Dto::Errors::NotFound.new('Location not found').to_h.to_json)
          end
        end

        context 'ExcludeLocation params is not a boolean' do
          it 'should return 400 HTTP Status' do
            city = create(:city)
            post :search, params: { location: city.slug, perimeter: 'department',  excludeLocation: "false"}

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('excludeLocation params should be a boolean.').to_h.to_json)
          end
        end
      end
      context 'GeolocOptions' do
        context 'longitude is missing' do
          it 'should return 400 HTTP Status' do
            post :search, params: {geolocOptions: { lat: -1.678979, radius: 1200 }}

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: long').to_h.to_json)
          end
        end

        context 'latitude is missing' do
          it 'should return 400 HTTP Status' do
            post :search, params: {geolocOptions: { long: 4.672382, radius: 1200 }}

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new('param is missing or the value is empty: lat').to_h.to_json)
          end
        end
      end
      context 'Category' do
        context 'Category not found' do
          it 'should return 404 HTTP Status' do
            Category.destroy_all

            post :search, params: { category: 'test' }

            expect(response).to have_http_status(:not_found)
            expect(response.body).to eq(Dto::Errors::NotFound.new("Couldn't find Category").to_h.to_json)
          end
        end
      end
      context 'PerPage params' do
        context 'PerPage params is not an integer' do
          it 'should return 400 HTTP Status' do
            city = create(:city)
            post :search, params: { location: city.slug, perPage: '12' }

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("perPage params must be an integer between 1 and 32.").to_h.to_json)
          end
        end

        context 'PerPage params is not an integer' do
          it 'should return 400 HTTP Status' do
            city = create(:city)
            post :search, params: { location: city.slug, perPage: 3000000 }

            expect(response).to have_http_status(:bad_request)
            expect(response.body).to eq(Dto::Errors::BadRequest.new("perPage params must be an integer between 1 and 32.").to_h.to_json)
          end
        end
      end
    end
  end

  private

  def random_shops_options
    {
      :page => 1,
      :per_page => 15,
      :padding => 0,
      :load => false,
      :includes => nil,
      :model_includes => nil,
      :json => true,
      :match_suffix => "analyzed",
      :highlight => nil,
      :highlighted_fields => [],
      :misspellings => false,
      :term => "*",
      :scope_results => nil,
      :total_entries => nil,
      :index_mapping => nil,
      :suggest => nil,
      :scroll => nil
    }
  end

  def random_shops_response
    { "took" => 5,
      "timed_out" => false,
      "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
      "hits" =>
        { "total" => { "value" => 3, "relation" => "eq" },
          "max_score" => 0.8669959,
          "hits" =>
            [
              { "_index" => "shops_v1_20210314105410121",
                "_type" => "_doc",
                "_id" => "4366",
                "_score" => 0.8669959,
                "_source" =>
                  { "name" => "BONJOUR ET BIENVENUE CHEZ EMILIENNE",
                    "created_at" => "2020-04-30T11:20:44.965+02:00",
                    "updated_at" => "2020-04-30T19:45:14.627+02:00",
                    "slug" => "bonjour-et-bienvenue-chez-emilienne",
                    "shop_url" => "/fr/lecussan/boutiques/bonjour-et-bienvenue-chez-emilienne",
                    "in_holidays" => false,
                    "category_tree_ids" => [3189, 3224, 3229],
                    "category_tree_names" => ["Beauté et santé", "Bain et Douche", "Savon"],
                    "baseline" => nil,
                    "description" => nil,
                    "brands_name" => ["CORVETTE", "RAMPAL-LATOUR", "RAMPAL -LATOUR", "EMBAZAC", "K NATURE"],
                    "city_label" => "Lécussan",
                    "city_slug" => "lecussan",
                    "insee_code" => "31289",
                    "territory_name" => nil,
                    "territory_slug" => nil,
                    "department_number" => "31",
                    "deleted_at" => nil,
                    "number_of_online_products" => 19,
                    "number_of_orders" => 0,
                    "image_url" => "default_box_shop.svg",
                    "coupons" => "[]",
                    "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                    "pictogram_url" => nil,
                    "services" => ["e-reservation", "livraison-par-colissimo", "livraison-express-par-stuart", "click-collect"],
                    "is_template" => false,
                    "score" => 0,
                    "indexed_at" => "2021-09-27T14:23:24.821+02:00" } },
              { "_index" => "shops_v1_20210314105410121",
                "_type" => "_doc",
                "_id" => "3950",
                "_score" => 0.45428866,
                "_source" =>
                  { "name" => "Liberty Fleurs Muret",
                    "created_at" => "2020-04-23T18:23:26.029+02:00",
                    "updated_at" => "2021-05-06T17:14:45.587+02:00",
                    "slug" => "liberty-fleurs-muret",
                    "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                    "shop_url" => "/fr/muret/boutiques/liberty-fleurs-muret",
                    "in_holidays" => false,
                    "category_tree_ids" => [2333, 2332, 2338, 2335, 2835, 2923, 2965, 2972],
                    "category_tree_names" =>
                      ["Bouquet de fleurs",
                       "Fleurs et plantes",
                       "Plantes et fleurs artificielles",
                       "Plantes intérieures",
                       "Mode",
                       "Homme",
                       "Maroquinerie",
                       "Porte-cartes"],
                    "baseline" => nil,
                    "description" => nil,
                    "brands_name" => [""],
                    "city_label" => "Muret",
                    "city_slug" => "muret",
                    "insee_code" => "31395",
                    "territory_name" => nil,
                    "territory_slug" => nil,
                    "department_number" => "31",
                    "deleted_at" => nil,
                    "number_of_online_products" => 39,
                    "number_of_orders" => 22,
                    "image_url" =>
                      "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/82807/file/thumb-15e
4bb745122714dd9c410ba1241474d.jpg",
                    "coupons" => "[]",
                    "pictogram_url" => nil,
                    "services" =>
                      ["e-reservation",
                       "livraison-par-colissimo",
                       "livraison-express-par-stuart",
                       "click-collect",
                       "livraison-par-le-commercant"],
                    "is_template" => false,
                    "score" => 38,
                    "indexed_at" => "2021-09-30T12:28:50.595+02:00" } },
              { "_index" => "shops_v1_20210314105410121",
                "_type" => "_doc",
                "_id" => "1093",
                "_score" => 0.27758718,
                "_source" =>
                  { "name" => "2e Chance",
                    "created_at" => "2020-03-26T09:09:09.639+01:00",
                    "updated_at" => "2020-04-07T13:51:18.309+02:00",
                    "slug" => "2e-chance",
                      "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                    "shop_url" => "/fr/saint-orens-de-gameville/boutiques/2e-chance",
                    "category_tree_ids" => [2565, 2579, 2580, 2649, 2666, 2835, 2836, 2837, 2853, 2895, 2906],
                    "category_tree_names" =>
                      ["Maison et bricolage",
                       "Décoration",
                       "Coussin",
                       "Linge de maison",
                       "Linge de table",
                       "Mode",
                       "Femme",
                       "Vêtements",
                       "Veste",
                       "Maroquinerie",
                       "Accessoires"],
                    "baseline" => nil,
                    "description" => nil,
                    "brands_name" => ["2e Chance"],
                    "city_label" => "Saint-Orens-de-Gameville",
                    "city_slug" => "saint-orens-de-gameville",
                    "insee_code" => "31506",
                    "territory_name" => nil,
                    "territory_slug" => nil,
                    "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                    "department_number" => "31",
                    "deleted_at" => nil,
                    "number_of_online_products" => 12,
                    "number_of_orders" => 0,
                    "image_url" =>
                      "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/42140/file/thumb-e50
a4a9e7fe915de4f7b9e438df35e06.jpg",
                    "coupons" => "[]",
                    "pictogram_url" => nil,
                    "services" =>
                      ["click-collect",
                       "livraison-par-le-commercant",
                       "livraison-express-par-stuart",
                       "livraison-par-la-poste",
                       "livraison-par-colissimo",
                       "e-reservation"],
                    "is_template" => false,
                    "score" => 0,
                    "indexed_at" => "2021-06-28T10:58:35.109+00:00" } }] },
      "aggregations" =>
        { "category_tree_ids" =>
            { "doc_count" => 3,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 2835, "doc_count" => 2 },
                 { "key" => 2332, "doc_count" => 1 },
                 { "key" => 2333, "doc_count" => 1 },
                 { "key" => 2335, "doc_count" => 1 },
                 { "key" => 2338, "doc_count" => 1 },
                 { "key" => 2565, "doc_count" => 1 },
                 { "key" => 2579, "doc_count" => 1 },
                 { "key" => 2580, "doc_count" => 1 },
                 { "key" => 2649, "doc_count" => 1 },
                 { "key" => 2666, "doc_count" => 1 },
                 { "key" => 2836, "doc_count" => 1 },
                 { "key" => 2837, "doc_count" => 1 },
                 { "key" => 2853, "doc_count" => 1 },
                 { "key" => 2895, "doc_count" => 1 },
                 { "key" => 2906, "doc_count" => 1 },
                 { "key" => 2923, "doc_count" => 1 },
                 { "key" => 2965, "doc_count" => 1 },
                 { "key" => 2972, "doc_count" => 1 },
                 { "key" => 3189, "doc_count" => 1 },
                 { "key" => 3224, "doc_count" => 1 },
                 { "key" => 3229, "doc_count" => 1 }] },
          "brands_name" =>
            { "doc_count" => 3,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "", "doc_count" => 1 },
                 { "key" => "2e Chance", "doc_count" => 1 },
                 { "key" => "CORVETTE", "doc_count" => 1 },
                 { "key" => "EMBAZAC", "doc_count" => 1 },
                 { "key" => "K NATURE", "doc_count" => 1 },
                 { "key" => "RAMPAL -LATOUR", "doc_count" => 1 },
                 { "key" => "RAMPAL-LATOUR", "doc_count" => 1 }] },
          "services" =>
            { "doc_count" => 3,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "click-collect", "doc_count" => 3 },
                 { "key" => "e-reservation", "doc_count" => 3 },
                 { "key" => "livraison-express-par-stuart", "doc_count" => 3 },
                 { "key" => "livraison-par-colissimo", "doc_count" => 3 },
                 { "key" => "livraison-par-le-commercant", "doc_count" => 2 },
                 { "key" => "livraison-par-la-poste", "doc_count" => 1 }] } } }
  end

  def highest_shops_options
    {
      :page => 1,
      :per_page => 9,
      :padding => 0,
      :load => false,
      :includes => nil,
      :model_includes => nil,
      :json => false,
      :match_suffix => "analyzed",
      :highlight => nil,
      :highlighted_fields => [],
      :misspellings => false,
      :term => "*",
      :scope_results => nil,
      :total_entries => nil,
      :index_mapping => nil,
      :suggest => nil,
      :scroll => nil
    }
  end

  def highest_shops_response
    {
      "took" => 2,
      "timed_out" => false,
      "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
      "hits" =>
        { "total" => { "value" => 3, "relation" => "eq" },
          "max_score" => nil,
          "hits" =>
            [{ "_index" => "shops_v1_20210314105410121",
               "_type" => "_doc",
               "_id" => "4223",
               "_score" => nil,
               "_source" =>
                 { "name" => "Saveurs et Harmonie",
                   "created_at" => "2020-04-27T20:14:44.770+02:00",
                   "updated_at" => "2021-07-26T09:51:22.592+02:00",
                   "slug" => "saveurs-et-harmonie",
                   "shop_url" => "/fr/toulouse/boutiques/saveurs-et-harmonie",
                   "in_holidays" => false,
                   "category_tree_ids" => [2054, 2257, 2249, 2250, 2251],
                   "category_tree_names" => ["Alimentation", "Infusion bien-être", "Thé et infusion", "Thé noir", "Thé parfumé"],
                   "baseline" => nil,
                   "description" => nil,
                   "brands_name" => [""],
                   "city_label" => "Toulouse",
                   "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                   "city_slug" => "toulouse",
                   "insee_code" => "31555",
                   "territory_name" => "Toulouse",
                   "territory_slug" => "toulouse",
                   "department_number" => "31",
                   "deleted_at" => nil,
                   "number_of_online_products" => 5,
                   "number_of_orders" => 4,
                   "image_url" =>
                     "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90775/file/thumb-ff6da91d1e3c4cbf9fe11312c1175942.jpg",
                   "coupons" =>
                     "[{\"id\":1100,\"label\":\"foo\",\"start_at\":\"2021-06-01\",\"end_at\":\"2021-09-30\",\"state\":\"active\",\"image_url\":\"https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/103008/file/06bed65f6992484f4ac9dcec3ea3f0a2.jpeg\"}]",
                   "pictogram_url" => nil,
                   "services" =>
                     ["e-reservation",
                      "livraison-par-colissimo",
                      "livraison-express-par-stuart",
                      "click-collect",
                      "livraison-par-le-commercant"],
                   "is_template" => false,
                   "score" => 4,
                   "indexed_at" => "2021-09-30T12:43:28.984+02:00" },
               "sort" => [4] },
             { "_index" => "shops_v1_20210314105410121",
               "_type" => "_doc",
               "_id" => "4146",
               "_score" => nil,
               "_source" =>
                 { "name" => "iep-shoes.com",
                   "created_at" => "2020-04-26T13:32:41.995+02:00",
                   "updated_at" => "2021-05-06T17:16:00.275+02:00",
                   "slug" => "iep-shoes-com",
                   "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
                   "shop_url" => "/fr/toulouse/boutiques/iep-shoes-com",
                   "in_holidays" => false,
                   "category_tree_ids" => [3025, 3024, 2835, 2988, 3080, 3082, 3050, 2954, 2962, 2923, 2878, 2881, 2836],
                   "category_tree_names" =>
                     ["Ballerines",
                      "Chaussures",
                      "Mode",
                      "Fille",
                      "Chaussures",
                      "Boots",
                      "Garçon",
                      "Chaussures",
                      "Chaussures de sport",
                      "Homme",
                      "Chaussures",
                      "Escarpins",
                      "Femme"],
                   "baseline" => nil,
                   "description" => nil,
                   "brands_name" => ["", "Tom et Eva", "Tom & Eva", "Chic Nana", "Ideal Shoes", "Lov'it"],
                   "city_label" => "Toulouse",
                   "city_slug" => "toulouse",
                   "insee_code" => "31555",
                   "territory_name" => "Toulouse",
                   "territory_slug" => "toulouse",
                   "department_number" => "31",
                   "deleted_at" => nil,
                   "number_of_online_products" => 8,
                   "number_of_orders" => 1,
                   "image_url" => "default_box_shop.svg",
                   "coupons" => "[]",
                   "pictogram_url" => nil,
                   "services" =>
                     ["e-reservation",
                      "livraison-par-colissimo",
                      "livraison-express-par-stuart",
                      "click-collect",
                      "livraison-par-le-commercant"],
                   "is_template" => false,
                   "score" => 1,
                   "indexed_at" => "2021-09-30T12:43:28.920+02:00" },
               "sort" => [1] },
             { "_index" => "shops_v1_20210314105410121",
               "_type" => "_doc",
               "_id" => "2247",
               "_score" => nil,
               "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
               "_source" =>
                 { "name" => "MODI IN ",
                   "created_at" => "2020-04-11T14:37:01.615+02:00",
                   "updated_at" => "2020-04-11T15:52:24.743+02:00",
                   "slug" => "modi-in",
                   "shop_url" => "/fr/toulouse/boutiques/modi-in",
                   "in_holidays" => false,
                   "category_tree_ids" => [3081, 3080, 2835, 3050, 2878, 2836, 2884],
                   "category_tree_names" => ["Baskets", "Chaussures", "Mode", "Garçon", "Chaussures", "Femme", "Mules et sabots"],
                   "baseline" => nil,
                   "description" => nil,
                   "brands_name" => ["SEMERDJIAN ", "SEMERDJIAN", "KAOLA"],
                   "city_label" => "Toulouse",
                   "city_slug" => "toulouse",
                   "insee_code" => "31555",
                   "territory_name" => "Toulouse",
                   "territory_slug" => "toulouse",
                   "department_number" => "31",
                   "deleted_at" => nil,
                   "number_of_online_products" => 3,
                   "number_of_orders" => 0,
                   "image_url" =>
                     "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/49098/file/thumb-447d0
dc383bbcbe8c9d8586bb2d20283.jpg",
                   "coupons" => "[]",
                   "pictogram_url" => nil,
                   "services" =>
                     ["e-reservation",
                      "livraison-par-colissimo",
                      "livraison-express-par-stuart",
                      "click-collect",
                      "livraison-par-le-commercant"],
                   "is_template" => false,
                   "score" => 0,
                   "indexed_at" => "2021-09-30T12:43:28.947+02:00" },
               "sort" => [0] }] },
      "aggregations" =>
        { "category_tree_ids" =>
            { "doc_count" => 3,
              "category_tree_ids" =>
                { "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => 2835, "doc_count" => 2 },
                     { "key" => 2836, "doc_count" => 2 },
                     { "key" => 2878, "doc_count" => 2 },
                     { "key" => 3050, "doc_count" => 2 },
                     { "key" => 3080, "doc_count" => 2 },
                     { "key" => 2054, "doc_count" => 1 },
                     { "key" => 2249, "doc_count" => 1 },
                     { "key" => 2250, "doc_count" => 1 },
                     { "key" => 2251, "doc_count" => 1 },
                     { "key" => 2257, "doc_count" => 1 },
                     { "key" => 2881, "doc_count" => 1 },
                     { "key" => 2884, "doc_count" => 1 },
                     { "key" => 2923, "doc_count" => 1 },
                     { "key" => 2954, "doc_count" => 1 },
                     { "key" => 2962, "doc_count" => 1 },
                     { "key" => 2988, "doc_count" => 1 },
                     { "key" => 3024, "doc_count" => 1 },
                     { "key" => 3025, "doc_count" => 1 },
                     { "key" => 3081, "doc_count" => 1 },
                     { "key" => 3082, "doc_count" => 1 }] } },
          "brands_name" =>
            { "doc_count" => 3,
              "brands_name" =>
                { "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "", "doc_count" => 2 },
                     { "key" => "Chic Nana", "doc_count" => 1 },
                     { "key" => "Ideal Shoes", "doc_count" => 1 },
                     { "key" => "KAOLA", "doc_count" => 1 },
                     { "key" => "Lov'it", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN ", "doc_count" => 1 },
                     { "key" => "Tom & Eva", "doc_count" => 1 },
                     { "key" => "Tom et Eva", "doc_count" => 1 }] } },
          "services" =>
            { "doc_count" => 3,
              "services" =>
                { "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "click-collect", "doc_count" => 3 },
                     { "key" => "e-reservation", "doc_count" => 3 },
                     { "key" => "livraison-express-par-stuart", "doc_count" => 3 },
                     { "key" => "livraison-par-colissimo", "doc_count" => 3 },
                     { "key" => "livraison-par-le-commercant", "doc_count" => 3 }] } } }
    }
  end

  def product_shops_response
    {"took"=>4,
     "timed_out"=>false,
     "_shards"=>{"total"=>1, "successful"=>1, "skipped"=>0, "failed"=>0},
     "hits"=>
       {"total"=>{"value"=>2, "relation"=>"eq"},
        "max_score"=>1.0,
        "hits"=>
          [{"_index"=>"shops_v1_20210314105410121",
            "_type"=>"_doc",
            "_id"=>"352",
            "_score"=>1.0,
            "_source"=>
              {"name"=>"AMOS",
               "created_at"=>"2017-10-24T16:18:33.475+02:00",
               "updated_at"=>"2020-03-26T18:32:35.971+01:00",
               "slug"=>"amos",
               "shop_url"=>"/fr/bordeaux/boutiques/amos",
               "in_holidays"=>false,
               "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
               "category_tree_ids"=>[2565, 2621, 2625, 3422],
               "category_tree_names"=>
                 ["Maison et bricolage", "Art de la table", "Carafe à eau", "Chèque cadeau et bon d'achat"],
               "baseline"=>"Vivez la mode solidaire ",
               "description"=>
                 "Notre boutique solidaire vend des vêtements, chaussures, accessoires et linges de maison donnés et recyclés.",
               "brands_name"=>["yopo", "poumpoum"],
               "city_label"=>"Bordeaux",
               "city_slug"=>"bordeaux",
               "insee_code"=>"33063",
               "territory_name"=>nil,
               "territory_slug"=>nil,
               "department_number"=>"33",
               "deleted_at"=>nil,
               "number_of_online_products"=>2,
               "number_of_orders"=>0,
               "image_url"=>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/25891/file/thumb-5c029f756a18d81b7d5c2b23f8cdf785.jpg",
               "coupons"=>"[]",
               "pictogram_url"=>nil,
               "services"=>["e-reservation", "livraison-par-colissimo", "livraison-express-par-stuart", "click-collect"],
               "is_template"=>false,
               "score"=>0,
               "indexed_at"=>"2021-09-30T12:38:59.879+02:00"}},
           {"_index"=>"shops_v1_20210314105410121",
            "_type"=>"_doc",
            "_id"=>"4760",
            "_score"=>1.0,
            "_source"=>
              {"name"=>"Sybille Crd",
               "created_at"=>"2020-07-17T17:40:20.808+02:00",
               "updated_at"=>"2021-05-06T17:16:53.781+02:00",
               "slug"=>"sybille-crd",
               "location"=>{"lat"=>45.79923399999999, "lon"=>4.8470666},
               "shop_url"=>"/fr/bordeaux/boutiques/sybille-crd",
               "in_holidays"=>false,
               "category_tree_ids"=>[2635, 2565, 2621, 2054, 2127, 2115, 2906, 2835, 2908, 2836],
               "category_tree_names"=>
                 ["Accessoires à vin",
                  "Maison et bricolage",
                  "Art de la table",
                  "Alimentation",
                  "Grillades",
                  "Viande",
                  "Accessoires",
                  "Mode",
                  "Bague",
                  "Femme"],
               "baseline"=>"Lorem ipsum dolor sit amet",
               "description"=>"Lorem ipsum dolor sit amet",
               "brands_name"=>["Anonyme", "Agapanthe ", "Chateau Loustalet"],
               "city_label"=>"Bordeaux",
               "city_slug"=>"bordeaux",
               "insee_code"=>"33063",
               "territory_name"=>nil,
               "territory_slug"=>nil,
               "department_number"=>"33",
               "deleted_at"=>nil,
               "number_of_online_products"=>3,
               "number_of_orders"=>2,
               "image_url"=>"default_box_shop.svg",
               "coupons"=>"[]",
               "pictogram_url"=>nil,
               "services"=>["e-reservation", "livraison-par-colissimo", "livraison-express-par-stuart", "click-collect"],
               "is_template"=>false,
               "score"=>2,
               "indexed_at"=>"2021-09-30T12:38:53.547+02:00"}}]},
     "aggregations"=>
       {"category_tree_ids"=>
          {"doc_count"=>2,
           "category_tree_ids"=>
             {"doc_count_error_upper_bound"=>0,
              "sum_other_doc_count"=>0,
              "buckets"=>
                [{"key"=>2565, "doc_count"=>2},
                 {"key"=>2621, "doc_count"=>2},
                 {"key"=>2054, "doc_count"=>1},
                 {"key"=>2115, "doc_count"=>1},
                 {"key"=>2127, "doc_count"=>1},
                 {"key"=>2625, "doc_count"=>1},
                 {"key"=>2635, "doc_count"=>1},
                 {"key"=>2835, "doc_count"=>1},
                 {"key"=>2836, "doc_count"=>1},
                 {"key"=>2906, "doc_count"=>1},
                 {"key"=>2908, "doc_count"=>1},
                 {"key"=>3422, "doc_count"=>1}]}},
        "brands_name"=>
          {"doc_count"=>2,
           "brands_name"=>
             {"doc_count_error_upper_bound"=>0,
              "sum_other_doc_count"=>0,
              "buckets"=>
                [{"key"=>"Agapanthe ", "doc_count"=>1},
                 {"key"=>"Anonyme", "doc_count"=>1},
                 {"key"=>"Chateau Loustalet", "doc_count"=>1},
                 {"key"=>"poumpoum", "doc_count"=>1},
                 {"key"=>"yopo", "doc_count"=>1}]}},
        "services"=>
          {"doc_count"=>2,
           "services"=>
             {"doc_count_error_upper_bound"=>0,
              "sum_other_doc_count"=>0,
              "buckets"=>
                [{"key"=>"click-collect", "doc_count"=>2},
                 {"key"=>"e-reservation", "doc_count"=>2},
                 {"key"=>"livraison-express-par-stuart", "doc_count"=>2},
                 {"key"=>"livraison-par-colissimo", "doc_count"=>2}]}}}}
  end

  def product_shops_options
    {:page=>1,
     :per_page=>15,
     :padding=>0,
     :load=>false,
     :includes=>nil,
     :model_includes=>nil,
     :json=>false,
     :match_suffix=>"analyzed",
     :highlight=>nil,
     :highlighted_fields=>[],
     :misspellings=>false,
     :term=>"*",
     :scope_results=>nil,
     :total_entries=>nil,
     :index_mapping=>nil,
     :suggest=>nil,
     :scroll=>nil}
  end
end
