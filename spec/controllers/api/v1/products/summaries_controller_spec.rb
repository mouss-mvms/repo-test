require 'rails_helper'

RSpec.describe Api::V1::Products::SummariesController do
  describe "GET #index" do
    context "All ok" do
      it "should return HTTP status 200 and an array of product-summaries" do
        location = create(:city)
        searchkick_result = Searchkick::HashWrapper.new({ "_index" => "products_v1_20210315162727103", "_type" => "_doc", "_id" => "2635", "_score" => nil, "id" => 2635, "name" => "Savon d'Alep Tradition 200 g", "slug" => "savon-d-alep-tradition-250-g", "createdAt" => "2017-04-20T15:19:26.137+02:00", "updatedAt" => "2021-05-06T11:47:06.312+02:00", "description" => "Savon d'Alep Tradition poids 200 g.\r\nIl est fabriqué selon la méthode ancestrale par un Maître Savonnier d'Alep. \r\nIl ne désseche pas la peau on peut l'utiliser en shampoing notamment comme anti-pelliculaire.\r\nIl est nourrissant, hydratant et il a des propriétés purifiantes et antiseptiques. \r\nIl convient parfaitement aux peaux sensibles ou peaux à problèmes (rougeurs, irritations..).", "basePrice" => 6.9, "goodDealStartsAt" => nil, "goodDealEndsAt" => nil, "price" => 6.9, "quantity" => 7, "categoryId" => 3190, "categoryTreeNames" => ["Beauté et santé", "Soin visage"], "categoryTreeIds" => [3189, 3190], "status" => "online", "shopName" => "LA MAISON DU SAVON DE MARSEILLE ", "shopId" => 271, "shopSlug" => "la-maison-du-savon-de-marseille", "inHolidays" => nil, "brandName" => "La Maison du Savon de Marseille", "brandId" => 818, "cityName" => "Pau", "cityLabel" => nil, "citySlug" => "pau", "conurbationSlug" => "pau", "inseeCode" => "64445", "territoryName" => nil, "territorySlug" => nil, "departmentNumber" => "64", "productCitizenNickname" => "Céline", "productCitizenSlug" => "celine", "productcitizenImagePath" => "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/8762/file/thumb-510229dfbc2330148a1a2b73b607c936.jpg", "defaultSampleId" => 3685, "shopPictogramUrl" => "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/9365/file/thumb-7805deea2addd0cb852e84fb6727295a.jpg", "imageUrl" => "https://e-city.s3.eu-central-1.amazonaws.com/images/files/000/009/338/thumb/IMG_3951.JPG?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIDWT2IFATUZXDWCA%2F20210628%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20210628T112832Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host&X-Amz-Signature=62d57b4d03b7a043a69b23d6f7dd1bfd5169c34b360d9bfddf10e75471222e61", "productPageUrl" => "https://mavillemonshopping-dev.herokuapp.com/fr/pau/la-maison-du-savon-de-marseille/beaute-et-sante/soin-visage/produits/savon-d-alep-tradition-250-g", "shopUrl" => "/fr/pau/boutiques/la-maison-du-savon-de-marseille", "numberOfOrders" => 1, "colors" => ["Modèle par défaut"], "sizes" => [], "selectionIds" => [5, 35, 5, 35, 5, 35], "services" => ["click-collect", "livraison-express-par-stuart", "livraison-par-la-poste", "livraison-par-colissimo", "e-reservation"], "shopIsTemplate" => false, "score" => 3, "position" => nil, "indexedAt" => "2021-06-28T11:28:32.714+00:00", "uniqueReferenceId" => 6353, "isAService" => nil, "onDiscount" => false, "discountPrice" => 6.9 })
        allow(::Requests::ProductSearches).to receive(:search_highest_scored_products).and_return(OpenStruct.new(products: [searchkick_result]))
        allow(::Requests::ProductSearches).to receive(:search_random_products).and_return([searchkick_result])
        get :index, params: { location: location.slug }
        should respond_with(200)
        response_body = JSON.load(response.body)
        expect(response_body).to be_instance_of(Array)
      end
    end

    context "Bad params" do
      context "when location_slug is missing" do
        it "should return HTTP status BadRequest - 400" do
          get :index
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: location").to_h.to_json)
        end
      end

      context "when location_slug params is blank" do
        it "should return HTTP status BadRequest - 400" do
          get :index, params: { location: "" }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: location").to_h.to_json)
        end
      end

      context "when city or territory does not exist" do
        it "should return HTTP status NotFound - 404" do
          get :index, params: { location: "bagdad" }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Location not found.").to_h.to_json)
        end
      end

      context "when category doesn't exist" do
        it "should return HTTP status NotFound - 404" do
          location = create(:city)
          get :index, params: { location: location.slug, categories: ["casque-radio-star-wars"] }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Category not found.").to_h.to_json)
        end
      end
    end
  end

  describe "POST #search" do
    context "All ok" do
      context "with highest_score" do
        it "should return HTTP status 200 and search object" do
          location = create(:city)
          page = 1
          option = { :page => 1,
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
                     :scroll => nil }
          searchkick_response = { "took" => 6,
                                  "timed_out" => false,
                                  "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
                                  "hits" =>
                                    { "total" => { "value" => 1, "relation" => "eq" },
                                      "max_score" => 0.82606244,
                                      "hits" =>
                                        [{ "_index" => "products_v1_20210315162727103",
                                           "_type" => "_doc",
                                           "_id" => "212466",
                                           "_score" => 0.82606244,
                                           "_source" =>
                                             { "id" => 212466,
                                               "name" => "Test Bordeaux",
                                               "slug" => "test-bordeaux",
                                               "created_at" => "2021-03-16T17:29:08.284+01:00",
                                               "updated_at" => "2021-03-16T17:29:09.513+01:00",
                                               "base_price" => 10.0,
                                               "active_good_deal" => false,
                                               "price" => 10.0,
                                               "quantity" => 99,
                                               "category_id" => 317,
                                               "category_tree_names" => ["Alimentaire et première nécéssité", "Bières & Cidres", "Blondes"],
                                               "category_tree_ids" => [11, 289, 317],
                                               "status" => "online",
                                               "shop_name" => "testbordeaux",
                                               "shop_id" => 14440,
                                               "shop_slug" => "testbordeaux",
                                               "brand_name" => "",
                                               "brand_id" => 5,
                                               "city_name" => "Bordeaux",
                                               "city_slug" => "bordeaux",
                                               "conurbation_slug" => "bordeaux",
                                               "insee_code" => "33063",
                                               "territory_name" => "Bordeaux Métropole",
                                               "territory_slug" => "bordeaux-metropole",
                                               "department_number" => "33",
                                               "product_citizen_nickname" => nil,
                                               "product_citizen_slug" => nil,
                                               "product_citizen_image_path" => nil,
                                               "default_sample_id" => 248487,
                                               "shop_pictogram_url" => "img_default_product.jpg",
                                               "image_url" => "img_default_product.jpg",
                                               "product_page_url" =>
                                                 "/fr/bordeaux/bordeaux/testbordeaux/test-bordeaux?product_id=212466#248487",
                                               "shop_url" => "/fr/bordeaux/bordeaux/testbordeaux",
                                               "number_of_orders" => 1,
                                               "colors" => ["Test Bordeaux"],
                                               "sizes" => [] } }] },
                                  "aggregations" =>
                                    { "category_tree_ids" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => 11, "doc_count" => 1 }, { "key" => 289, "doc_count" => 1 }, { "key" => 317, "doc_count" => 1 }] },
                                      "sizes" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [] },
                                      "base_price" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => 10.0, "doc_count" => 1 }] },
                                      "brand_name" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => "", "doc_count" => 1 }] },
                                      "services" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [] },
                                      "colors" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => "Test Bordeaux", "doc_count" => 1 }] } } }
          highest_score_product_response = [{ "_index" => "products_v1_20210315162727103",
                                              "_type" => "_doc",
                                              "_id" => "1794",
                                              "_score" => nil,
                                              "sort" => [11],
                                              "id" => 1794,
                                              "name" => "Cidre Appie  - Brut",
                                              "slug" => "cidre-appie",
                                              "created_at" => "2017-02-06T17:19:24.234+01:00",
                                              "updated_at" => "2021-07-15T15:14:07.772+02:00",
                                              "description" =>
                                                "Le cidre qui va vous faire REDECOUVRIR le cidre !\r\nUne jolie robe dorée. Assemblage de pommes douces aux notes florales et de pommes amères, agrémenté d'une touche de poiré qui rend cette recette si originale. Un goût fruité mais peu sucré, sec et légèrement acidulé.\r\n100% naturel : des fruits pressés uniquement \r\nSans sucres ajoutés, sans concentrés et sans gluten (évidemment)",
                                              "base_price" => 3.2,
                                              "good_deal_starts_at" => nil,
                                              "good_deal_ends_at" => nil,
                                              "price" => 3.2,
                                              "quantity" => 1,
                                              "category_id" => 2303,
                                              "category_tree_names" => ["Vin et spiritueux", "Cidre", "Cidre brut"],
                                              "category_tree_ids" => [2278, 2302, 2303],
                                              "status" => "online",
                                              "shop_name" => "Le Comptoir du Bouteiller ",
                                              "shop_id" => 238,
                                              "shop_slug" => "comptoire-du-bouteiller",
                                              "in_holidays" => false,
                                              "brand_name" => "APPIE",
                                              "brand_id" => 578,
                                              "city_name" => "Bordeaux",
                                              "city_label" => "Bordeaux",
                                              "city_slug" => "bordeaux",
                                              "conurbation_slug" => "bordeaux",
                                              "insee_code" => "33063",
                                              "territory_name" => "Bordeaux",
                                              "territory_slug" => "bordeaux",
                                              "department_number" => "33",
                                              "product_citizen_nickname" => nil,
                                              "product_citizen_slug" => nil,
                                              "product_citizen_image_path" => nil,
                                              "default_sample_id" => 2554,
                                              "shop_pictogram_url" =>
                                                "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/6131/file/thumb-56a00f3d5c509aa4daf20d37f26f326e.jpg",
                                              "image_url" =>
                                                "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/6148/file/thumb-f0898ecd3eb79068fb61dcd5269b756e.jpg",
                                              "product_page_url" =>
                                                "https://mavillemonshopping-dev.herokuapp.com/fr/bordeaux/comptoire-du-bouteiller/vin-et-spiritueux/cidre/cidre-brut/produits/cidre-appie",
                                              "shop_url" => "/fr/bordeaux/boutiques/comptoire-du-bouteiller",
                                              "number_of_orders" => 5,
                                              "colors" => ["Modèle par défaut"],
                                              "sizes" => ["Bouteille 33cl"],
                                              "selection_ids" => [],
                                              "services" =>
                                                ["click-collect",
                                                 "livraison-express-par-stuart",
                                                 "livraison-par-la-poste",
                                                 "livraison-par-colissimo",
                                                 "e-reservation"],
                                              "shop_is_template" => false,
                                              "score" => 11,
                                              "position" => nil,
                                              "indexed_at" => "2021-09-03T14:39:56.611+02:00",
                                              "unique_reference_id" => 4278,
                                              "is_a_service" => false }, { "_index" => "products_v1_20210315162727103",
                                                                           "_type" => "_doc",
                                                                           "_id" => "47475",
                                                                           "_score" => nil,
                                                                           "sort" => [9],
                                                                           "id" => 47475,
                                                                           "name" => "Converse",
                                                                           "slug" => "converse",
                                                                           "created_at" => "2020-08-14T15:21:29.836+02:00",
                                                                           "updated_at" => "2021-08-25T12:07:40.475+02:00",
                                                                           "description" => "",
                                                                           "base_price" => 100.0,
                                                                           "good_deal_starts_at" => "2020-08-14T00:00:00.000+02:00",
                                                                           "good_deal_ends_at" => "2020-08-14T23:59:59.999+02:00",
                                                                           "price" => 100.0,
                                                                           "quantity" => 90,
                                                                           "category_id" => 2956,
                                                                           "category_tree_names" => ["Chaussures", "Mode", "Chaussures de ville", "Homme"],
                                                                           "category_tree_ids" => [2954, 2835, 2956, 2923],
                                                                           "status" => "online",
                                                                           "shop_name" => "Test",
                                                                           "shop_id" => 4745,
                                                                           "shop_slug" => "test-6",
                                                                           "in_holidays" => false,
                                                                           "brand_name" => "Converse",
                                                                           "brand_id" => 511,
                                                                           "city_name" => "Bordeaux",
                                                                           "city_label" => "Bordeaux",
                                                                           "city_slug" => "bordeaux",
                                                                           "conurbation_slug" => "bordeaux",
                                                                           "insee_code" => "33063",
                                                                           "territory_name" => "Bordeaux",
                                                                           "territory_slug" => "bordeaux",
                                                                           "department_number" => "33",
                                                                           "product_citizen_nickname" => nil,
                                                                           "product_citizen_slug" => nil,
                                                                           "product_citizen_image_path" => "cityzen.png",
                                                                           "default_sample_id" => 56955,
                                                                           "shop_pictogram_url" => "img_default_product.jpg",
                                                                           "image_url" =>
                                                                             "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/102708/file/t
humb-3425d0d5d27025919eeca7dadfbe691f.jpg",
                                                                           "product_page_url" =>
                                                                             "https://mavillemonshopping-dev.herokuapp.com/fr/bordeaux/test-6/mode/homme/chaussures/chaussures-de
-ville/produits/converse",
                                                                           "shop_url" => "/fr/bordeaux/boutiques/test-6",
                                                                           "number_of_orders" => 10,
                                                                           "colors" => ["Modèle par défaut"],
                                                                           "sizes" => [],
                                                                           "selection_ids" => [],
                                                                           "services" =>
                                                                             ["click-collect",
                                                                              "livraison-express-par-stuart",
                                                                              "livraison-par-la-poste",
                                                                              "livraison-par-colissimo",
                                                                              "e-reservation"],
                                                                           "shop_is_template" => false,
                                                                           "score" => 9,
                                                                           "position" => nil,
                                                                           "indexed_at" => "2021-09-03T14:40:38.072+02:00",
                                                                           "unique_reference_id" => 106690,

                                                                           "is_a_service" => false }]
          highest_scored_aggs_response = searchkick_response["aggregations"]
          random_scored_response = Searchkick::Results.new(Product, searchkick_response, option)
          response_hightest = Struct.new(:products,  :aggs)
          allow(::Requests::ProductSearches).to receive(:search_highest_scored_products).and_return(response_hightest.new(highest_score_product_response.map {|r| Searchkick::HashWrapper.new(r)}, highest_scored_aggs_response))
          allow(::Requests::ProductSearches).to receive(:search_random_products).and_return(random_scored_response)
          post :search, params: { location: location.slug, page: page }
          should respond_with(200)
          expect(response.body).to eq(Dto::V1::Product::Search::Response.create({ products: highest_score_product_response + random_scored_response.map { |p| p }, aggs: highest_scored_aggs_response, page: page }).to_h.to_json)
        end
      end

      context "without highest_score" do
        it "should return HTTP status 200 and search object" do
          location = create(:city)
          page = 1
          option = { :page => 1,
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
                     :scroll => nil }
          searchkick_response = { "took" => 6,
                                  "timed_out" => false,
                                  "_shards" => { "total" => 1, "successful" => 1, "skipped" => 0, "failed" => 0 },
                                  "hits" =>
                                    { "total" => { "value" => 1, "relation" => "eq" },
                                      "max_score" => 0.82606244,
                                      "hits" =>
                                        [{ "_index" => "products_v1_20210315162727103",
                                           "_type" => "_doc",
                                           "_id" => "212466",
                                           "_score" => 0.82606244,
                                           "_source" =>
                                             { "id" => 212466,
                                               "name" => "Test Bordeaux",
                                               "slug" => "test-bordeaux",
                                               "created_at" => "2021-03-16T17:29:08.284+01:00",
                                               "updated_at" => "2021-03-16T17:29:09.513+01:00",
                                               "base_price" => 10.0,
                                               "active_good_deal" => false,
                                               "price" => 10.0,
                                               "quantity" => 99,
                                               "category_id" => 317,
                                               "category_tree_names" => ["Alimentaire et première nécéssité", "Bières & Cidres", "Blondes"],
                                               "category_tree_ids" => [11, 289, 317],
                                               "status" => "online",
                                               "shop_name" => "testbordeaux",
                                               "shop_id" => 14440,
                                               "shop_slug" => "testbordeaux",
                                               "brand_name" => "",
                                               "brand_id" => 5,
                                               "city_name" => "Bordeaux",
                                               "city_slug" => "bordeaux",
                                               "conurbation_slug" => "bordeaux",
                                               "insee_code" => "33063",
                                               "territory_name" => "Bordeaux Métropole",
                                               "territory_slug" => "bordeaux-metropole",
                                               "department_number" => "33",
                                               "product_citizen_nickname" => nil,
                                               "product_citizen_slug" => nil,
                                               "product_citizen_image_path" => nil,
                                               "default_sample_id" => 248487,
                                               "shop_pictogram_url" => "img_default_product.jpg",
                                               "image_url" => "img_default_product.jpg",
                                               "product_page_url" =>
                                                 "/fr/bordeaux/bordeaux/testbordeaux/test-bordeaux?product_id=212466#248487",
                                               "shop_url" => "/fr/bordeaux/bordeaux/testbordeaux",
                                               "number_of_orders" => 1,
                                               "colors" => ["Test Bordeaux"],
                                               "sizes" => [] } }] },
                                  "aggregations" =>
                                    { "category_tree_ids" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => 11, "doc_count" => 1 }, { "key" => 289, "doc_count" => 1 }, { "key" => 317, "doc_count" => 1 }] },
                                      "sizes" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [] },
                                      "base_price" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => 10.0, "doc_count" => 1 }] },
                                      "brand_name" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => "", "doc_count" => 1 }] },
                                      "services" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [] },
                                      "colors" =>
                                        { "meta" => {},
                                          "doc_count" => 1,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" => [{ "key" => "Test Bordeaux", "doc_count" => 1 }] } } }
          random_scored_response = Searchkick::Results.new(Product, searchkick_response, option)

          allow(::Requests::ProductSearches).to receive(:search_random_products).and_return(random_scored_response)

          post :search, params: { location: location.slug, q: "Savon", page: page }
          should respond_with(200)

          expect(response.body).to eq(Dto::V1::Product::Search::Response.create({ products: random_scored_response.map { |p| p }, aggs: random_scored_response.aggs, page: page }).to_h.to_json)
          expect(::Requests::ProductSearches).not_to receive(:search_highest_scored_products)
        end
      end
    end

    context "Bad params" do
      context "when location_slug is missing" do
        it "should return HTTP status BadRequest - 400" do
          get :index
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: location").to_h.to_json)
        end
      end

      context "when location_slug params is blank" do
        it "should return HTTP status BadRequest - 400" do
          get :index, params: { location: "" }
          should respond_with(400)
          expect(response.body).to eq(Dto::Errors::BadRequest.new("param is missing or the value is empty: location").to_h.to_json)
        end
      end

      context "when city or territory does not exist" do
        it "should return HTTP status NotFound - 404" do
          get :index, params: { location: "bagdad" }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Location not found.").to_h.to_json)
        end
      end

      context "when category doesn't exist" do
        it "should return HTTP status NotFound - 404" do
          location = create(:city)
          get :index, params: { location: location.slug, categories: ["casque-radio-star-wars"] }
          should respond_with(404)
          expect(response.body).to eq(Dto::Errors::NotFound.new("Category not found.").to_h.to_json)
        end
      end
    end
  end
end
