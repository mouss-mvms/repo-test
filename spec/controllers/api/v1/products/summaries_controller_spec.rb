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
          response_hightest = Struct.new(:products, :aggs)
          allow(::Requests::ProductSearches).to receive(:search_highest_scored_products).and_return(response_hightest.new(highest_score_product_response.map { |r| Searchkick::HashWrapper.new(r) }, highest_scored_aggs_response))
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

      context "with shared products params" do
        it "should return HTTP status 200 and search object with only shared products" do
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
                                           "_id" => "2614",
                                           "_score" => 0.99950105,
                                           "id" => 2614,
                                           "name" => "Collier Epis",
                                           "slug" => "collier",
                                           "created_at" => "2017-04-19T10:12:11.447+02:00",
                                           "updated_at" => "2017-04-20T16:41:00.042+02:00",
                                           "description" => "",
                                           "base_price" => 24.9,
                                           "good_deal_starts_at" => nil,
                                           "good_deal_ends_at" => nil,
                                           "price" => 24.9,
                                           "quantity" => 4,
                                           "category_id" => 2975,
                                           "category_tree_names" => ["Accessoires", "Bijoux homme", "Mode", "Homme"],
                                           "category_tree_ids" => [2973, 2975, 2835, 2923],
                                           "status" => "online",
                                           "shop_name" => "Les Pépettes",
                                           "shop_id" => 209,
                                           "shop_slug" => "les-pepettes",
                                           "in_holidays" => false,
                                           "brand_name" => "",
                                           "brand_id" => 5,
                                           "city_name" => "Bordeaux",
                                           "city_label" => "Bordeaux",
                                           "city_slug" => "bordeaux",
                                           "conurbation_slug" => "bordeaux",
                                           "insee_code" => "33063",
                                           "territory_name" => "Bordeaux",
                                           "territory_slug" => "bordeaux",
                                           "department_number" => "33",
                                           "product_citizen_nickname" => "LuzCorner ",
                                           "product_citizen_slug" => "luzcorner",
                                           "product_citizen_image_path" =>
                                             "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/8458/file/thumb-53214a6ae6b8fa4e05c63e76c0ff7e16.jpg",
                                           "default_sample_id" => 3654,
                                           "shop_pictogram_url" =>
                                             "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/3651/file/thumb-22134597f703a1a64cbc486afa2bfd59.jpg",
                                           "image_url" =>
                                             "https://e-city.s3.eu-central-1.amazonaws.com/images/files/000/009/269/thumb/IMG_9636.JPG?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIDWT2IFATUZXDWCA%2F20211011%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20211011T092326Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host&X-Amz-Signature=6b4c325bcafaa9f4ae23d84dcb76dd3ca82fc11dafdb546c272ed058a45fc5ee",
                                           "product_page_url" =>
                                             "http://127.0.0.1:3000//bordeaux/les-pepettes/mode/homme/accessoires/bijoux-homme/produits/collier",
                                           "shop_url" => "/fr/bordeaux/boutiques/les-pepettes",
                                           "number_of_orders" => 0,
                                           "colors" => ["Bleu"],
                                           "sizes" => ["Taille unique"],
                                           "selection_ids" => [18, 27, 7, 35, 1, 14, 18, 27, 7, 35, 1, 14, 18, 27, 7, 35, 1, 14],
                                           "services" =>
                                             ["livraison-par-colissimo", "e-reservation", "diagana-youssouf", "click-collect", "livraison-express-par-stuart"],
                                           "shop_is_template" => false,
                                           "score" => 0,
                                           "position" => nil,
                                           "indexed_at" => "2021-10-11T11:23:26.149+02:00",
                                           "unique_reference_id" => 6311,
                                           "is_a_service" => nil }] },
                                  "aggregations" =>
                                    { "category_tree_ids" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => 2565, "doc_count" => 38 },
                                             { "key" => 2835, "doc_count" => 37 },
                                             { "key" => 2332, "doc_count" => 21 },
                                             { "key" => 2579, "doc_count" => 21 },
                                             { "key" => 2923, "doc_count" => 17 },
                                             { "key" => 2278, "doc_count" => 16 },
                                             { "key" => 2836, "doc_count" => 15 },
                                             { "key" => 2054, "doc_count" => 14 },
                                             { "key" => 2906, "doc_count" => 14 },
                                             { "key" => 2194, "doc_count" => 11 },
                                             { "key" => 2335, "doc_count" => 11 },
                                             { "key" => 2340, "doc_count" => 11 },
                                             { "key" => 2293, "doc_count" => 10 },
                                             { "key" => 2333, "doc_count" => 10 },
                                             { "key" => 2211, "doc_count" => 9 },
                                             { "key" => 2908, "doc_count" => 9 },
                                             { "key" => 2497, "doc_count" => 8 },
                                             { "key" => 2965, "doc_count" => 8 },
                                             { "key" => 2973, "doc_count" => 8 },
                                             { "key" => 2621, "doc_count" => 6 },
                                             { "key" => 2970, "doc_count" => 6 },
                                             { "key" => 2279, "doc_count" => 5 },
                                             { "key" => 2599, "doc_count" => 5 },
                                             { "key" => 2294, "doc_count" => 4 },
                                             { "key" => 2975, "doc_count" => 4 },
                                             { "key" => 2604, "doc_count" => 3 },
                                             { "key" => 2911, "doc_count" => 3 },
                                             { "key" => 2978, "doc_count" => 3 },
                                             { "key" => 2988, "doc_count" => 3 },
                                             { "key" => 3189, "doc_count" => 3 },
                                             { "key" => 2216, "doc_count" => 2 },
                                             { "key" => 2280, "doc_count" => 2 },
                                             { "key" => 2295, "doc_count" => 2 },
                                             { "key" => 2296, "doc_count" => 2 },
                                             { "key" => 2297, "doc_count" => 2 },
                                             { "key" => 2373, "doc_count" => 2 },
                                             { "key" => 2378, "doc_count" => 2 },
                                             { "key" => 2510, "doc_count" => 2 },
                                             { "key" => 2516, "doc_count" => 2 },
                                             { "key" => 2586, "doc_count" => 2 },
                                             { "key" => 2587, "doc_count" => 2 },
                                             { "key" => 2592, "doc_count" => 2 },
                                             { "key" => 2593, "doc_count" => 2 },
                                             { "key" => 2596, "doc_count" => 2 },
                                             { "key" => 2624, "doc_count" => 2 },
                                             { "key" => 2625, "doc_count" => 2 },
                                             { "key" => 2626, "doc_count" => 2 },
                                             { "key" => 2686, "doc_count" => 2 },
                                             { "key" => 2703, "doc_count" => 2 },
                                             { "key" => 2711, "doc_count" => 2 },
                                             { "key" => 2722, "doc_count" => 2 },
                                             { "key" => 2732, "doc_count" => 2 },
                                             { "key" => 2784, "doc_count" => 2 },
                                             { "key" => 2796, "doc_count" => 2 },
                                             { "key" => 2827, "doc_count" => 2 },
                                             { "key" => 2834, "doc_count" => 2 },
                                             { "key" => 2910, "doc_count" => 2 },
                                             { "key" => 2972, "doc_count" => 2 },
                                             { "key" => 2062, "doc_count" => 1 },
                                             { "key" => 2221, "doc_count" => 1 },
                                             { "key" => 2226, "doc_count" => 1 },
                                             { "key" => 2283, "doc_count" => 1 },
                                             { "key" => 2285, "doc_count" => 1 },
                                             { "key" => 2317, "doc_count" => 1 },
                                             { "key" => 2331, "doc_count" => 1 },
                                             { "key" => 2341, "doc_count" => 1 },
                                             { "key" => 2348, "doc_count" => 1 },
                                             { "key" => 2498, "doc_count" => 1 },
                                             { "key" => 2505, "doc_count" => 1 },
                                             { "key" => 2509, "doc_count" => 1 },
                                             { "key" => 2511, "doc_count" => 1 },
                                             { "key" => 2566, "doc_count" => 1 },
                                             { "key" => 2580, "doc_count" => 1 },
                                             { "key" => 2591, "doc_count" => 1 },
                                             { "key" => 2597, "doc_count" => 1 },
                                             { "key" => 2638, "doc_count" => 1 },
                                             { "key" => 2741, "doc_count" => 1 },
                                             { "key" => 2761, "doc_count" => 1 },
                                             { "key" => 2895, "doc_count" => 1 },
                                             { "key" => 2902, "doc_count" => 1 },
                                             { "key" => 2924, "doc_count" => 1 },
                                             { "key" => 2929, "doc_count" => 1 },
                                             { "key" => 2979, "doc_count" => 1 },
                                             { "key" => 2989, "doc_count" => 1 },
                                             { "key" => 2995, "doc_count" => 1 },
                                             { "key" => 3024, "doc_count" => 1 },
                                             { "key" => 3025, "doc_count" => 1 },
                                             { "key" => 3036, "doc_count" => 1 },
                                             { "key" => 3038, "doc_count" => 1 },
                                             { "key" => 3050, "doc_count" => 1 },
                                             { "key" => 3091, "doc_count" => 1 },
                                             { "key" => 3095, "doc_count" => 1 },
                                             { "key" => 3170, "doc_count" => 1 },
                                             { "key" => 3188, "doc_count" => 1 },
                                             { "key" => 3224, "doc_count" => 1 },
                                             { "key" => 3229, "doc_count" => 1 },
                                             { "key" => 3232, "doc_count" => 1 },
                                             { "key" => 3242, "doc_count" => 1 },
                                             { "key" => 3422, "doc_count" => 1 }] },
                                      "sizes" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => "Taille unique", "doc_count" => 15 },
                                             { "key" => "52", "doc_count" => 6 },
                                             { "key" => "Bouteille 75cl", "doc_count" => 6 },
                                             { "key" => "54", "doc_count" => 4 },
                                             { "key" => "50", "doc_count" => 3 },
                                             { "key" => "MOYEN", "doc_count" => 2 },
                                             { "key" => "1 tube", "doc_count" => 1 },
                                             { "key" => "2 tubes", "doc_count" => 1 },
                                             { "key" => "250ml", "doc_count" => 1 },
                                             { "key" => "3 tubes", "doc_count" => 1 },
                                             { "key" => "53", "doc_count" => 1 },
                                             { "key" => "56", "doc_count" => 1 },
                                             { "key" => "6 cm", "doc_count" => 1 },
                                             { "key" => "9 cm", "doc_count" => 1 },
                                             { "key" => "Avec Cadre", "doc_count" => 1 },
                                             { "key" => "GRAND", "doc_count" => 1 },
                                             { "key" => "K", "doc_count" => 1 },
                                             { "key" => "L", "doc_count" => 1 },
                                             { "key" => "M", "doc_count" => 1 },
                                             { "key" => "PETIT", "doc_count" => 1 },
                                             { "key" => "Sans Cadre", "doc_count" => 1 },
                                             { "key" => "TIGE", "doc_count" => 1 }] },
                                      "base_price" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => 35.0, "doc_count" => 6 },
                                             { "key" => 10.0, "doc_count" => 5 },
                                             { "key" => 5.199999809265137, "doc_count" => 4 },
                                             { "key" => 6.900000095367432, "doc_count" => 4 },
                                             { "key" => 12.0, "doc_count" => 4 },
                                             { "key" => 14.0, "doc_count" => 4 },
                                             { "key" => 25.0, "doc_count" => 4 },
                                             { "key" => 40.0, "doc_count" => 4 },
                                             { "key" => 55.0, "doc_count" => 4 },
                                             { "key" => 4.199999809265137, "doc_count" => 3 },
                                             { "key" => 13.899999618530273, "doc_count" => 3 },
                                             { "key" => 18.0, "doc_count" => 3 },
                                             { "key" => 30.0, "doc_count" => 3 },
                                             { "key" => 39.0, "doc_count" => 3 },
                                             { "key" => 3.5, "doc_count" => 2 },
                                             { "key" => 5.800000190734863, "doc_count" => 2 },
                                             { "key" => 5.900000095367432, "doc_count" => 2 },
                                             { "key" => 9.899999618530273, "doc_count" => 2 },
                                             { "key" => 12.5, "doc_count" => 2 },
                                             { "key" => 15.0, "doc_count" => 2 },
                                             { "key" => 16.0, "doc_count" => 2 },
                                             { "key" => 16.5, "doc_count" => 2 },
                                             { "key" => 21.0, "doc_count" => 2 },
                                             { "key" => 22.0, "doc_count" => 2 },
                                             { "key" => 23.899999618530273, "doc_count" => 2 },
                                             { "key" => 28.0, "doc_count" => 2 },
                                             { "key" => 28.899999618530273, "doc_count" => 2 },
                                             { "key" => 38.0, "doc_count" => 2 },
                                             { "key" => 44.9900016784668, "doc_count" => 2 },
                                             { "key" => 54.900001525878906, "doc_count" => 2 },
                                             { "key" => 65.0, "doc_count" => 2 },
                                             { "key" => 90.0, "doc_count" => 2 },
                                             { "key" => 1.75, "doc_count" => 1 },
                                             { "key" => 1.899999976158142, "doc_count" => 1 },
                                             { "key" => 2.0, "doc_count" => 1 },
                                             { "key" => 4.5, "doc_count" => 1 },
                                             { "key" => 4.800000190734863, "doc_count" => 1 },
                                             { "key" => 5.0, "doc_count" => 1 },
                                             { "key" => 6.699999809265137, "doc_count" => 1 },
                                             { "key" => 7.400000095367432, "doc_count" => 1 },
                                             { "key" => 8.0, "doc_count" => 1 },
                                             { "key" => 8.300000190734863, "doc_count" => 1 },
                                             { "key" => 9.0, "doc_count" => 1 },
                                             { "key" => 11.5, "doc_count" => 1 },
                                             { "key" => 16.899999618530273, "doc_count" => 1 },
                                             { "key" => 18.899999618530273, "doc_count" => 1 },
                                             { "key" => 20.0, "doc_count" => 1 },
                                             { "key" => 21.5, "doc_count" => 1 },
                                             { "key" => 23.0, "doc_count" => 1 },
                                             { "key" => 24.0, "doc_count" => 1 },
                                             { "key" => 24.5, "doc_count" => 1 },
                                             { "key" => 24.899999618530273, "doc_count" => 1 },
                                             { "key" => 26.899999618530273, "doc_count" => 1 },
                                             { "key" => 27.799999237060547, "doc_count" => 1 },
                                             { "key" => 29.0, "doc_count" => 1 },
                                             { "key" => 32.0, "doc_count" => 1 },
                                             { "key" => 34.0, "doc_count" => 1 },
                                             { "key" => 35.900001525878906, "doc_count" => 1 },
                                             { "key" => 36.0, "doc_count" => 1 },
                                             { "key" => 38.599998474121094, "doc_count" => 1 },
                                             { "key" => 42.0, "doc_count" => 1 },
                                             { "key" => 43.0, "doc_count" => 1 },
                                             { "key" => 45.0, "doc_count" => 1 },
                                             { "key" => 48.0, "doc_count" => 1 },
                                             { "key" => 49.0, "doc_count" => 1 },
                                             { "key" => 50.0, "doc_count" => 1 },
                                             { "key" => 52.0, "doc_count" => 1 },
                                             { "key" => 59.900001525878906, "doc_count" => 1 },
                                             { "key" => 73.0, "doc_count" => 1 },
                                             { "key" => 75.0, "doc_count" => 1 },
                                             { "key" => 79.0, "doc_count" => 1 },
                                             { "key" => 89.0, "doc_count" => 1 },
                                             { "key" => 125.0, "doc_count" => 1 },
                                             { "key" => 127.0, "doc_count" => 1 },
                                             { "key" => 129.0, "doc_count" => 1 },
                                             { "key" => 150.0, "doc_count" => 1 },
                                             { "key" => 175.0, "doc_count" => 1 },
                                             { "key" => 180.0, "doc_count" => 1 },
                                             { "key" => 249.0, "doc_count" => 1 }] },
                                      "brand_name" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => "", "doc_count" => 65 },
                                             { "key" => "Dock des Epices", "doc_count" => 8 },
                                             { "key" => "Mélanie Paolone", "doc_count" => 7 },
                                             { "key" => "Oya Fleurs", "doc_count" => 6 },
                                             { "key" => "Mira", "doc_count" => 4 },
                                             { "key" => "Bordeaux Beer Factory", "doc_count" => 3 },
                                             { "key" => "Arte Fact", "doc_count" => 2 },
                                             { "key" => "Artisan touareg", "doc_count" => 2 },
                                             { "key" => "Bitten", "doc_count" => 2 },
                                             { "key" => "Chaussures trop bien", "doc_count" => 2 },
                                             { "key" => "I Love Design", "doc_count" => 2 },
                                             { "key" => "Kitik", "doc_count" => 2 },
                                             { "key" => "La Parisienne", "doc_count" => 2 },
                                             { "key" => "Morelli ", "doc_count" => 2 },
                                             { "key" => "Oliviers & Co ", "doc_count" => 2 },
                                             { "key" => "Oliviers&Co", "doc_count" => 2 },
                                             { "key" => "Atelier Romain Bernex", "doc_count" => 1 },
                                             { "key" => "CALLIA", "doc_count" => 1 },
                                             { "key" => "Château La Favière", "doc_count" => 1 },
                                             { "key" => "Créatrice ", "doc_count" => 1 },
                                             { "key" => "DITTE FISCHER", "doc_count" => 1 },
                                             { "key" => "Domaine Jean Guiton", "doc_count" => 1 },
                                             { "key" => "EPOS", "doc_count" => 1 },
                                             { "key" => "Histoire d'écrire", "doc_count" => 1 },
                                             { "key" => "House of desaster", "doc_count" => 1 },
                                             { "key" => "KAY BØJESEN", "doc_count" => 1 },
                                             { "key" => "KORTKARTELLET", "doc_count" => 1 },
                                             { "key" => "Kortkartellet ", "doc_count" => 1 },
                                             { "key" => "LOVI", "doc_count" => 1 },
                                             { "key" => "LastSwab", "doc_count" => 1 },
                                             { "key" => "Little Paul&Joe", "doc_count" => 1 },
                                             { "key" => "Michel Redde & Fils", "doc_count" => 1 },
                                             { "key" => "OLIVIERS & CO", "doc_count" => 1 },
                                             { "key" => "Os à Voeux", "doc_count" => 1 },
                                             { "key" => "Oya Fleurs ", "doc_count" => 1 },
                                             { "key" => "Sun JUNIOR", "doc_count" => 1 },
                                             { "key" => "Very fresh gansters", "doc_count" => 1 },
                                             { "key" => "Westland", "doc_count" => 1 },
                                             { "key" => "Wheely Bug ", "doc_count" => 1 },
                                             { "key" => "being human", "doc_count" => 1 },
                                             { "key" => "djeco ", "doc_count" => 1 },
                                             { "key" => "dock des épices ", "doc_count" => 1 },
                                             { "key" => "poumpoum", "doc_count" => 1 },
                                             { "key" => "yopo", "doc_count" => 1 }] },
                                      "services" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => "click-collect", "doc_count" => 141 },
                                             { "key" => "diagana-youssouf", "doc_count" => 141 },
                                             { "key" => "e-reservation", "doc_count" => 141 },
                                             { "key" => "livraison-express-par-stuart", "doc_count" => 141 },
                                             { "key" => "livraison-par-colissimo", "doc_count" => 140 },
                                             { "key" => "livraison-par-le-commercant", "doc_count" => 3 },
                                             { "key" => "livraison-de-proximite", "doc_count" => 2 }] },
                                      "colors" =>
                                        { "doc_count" => 141,
                                          "doc_count_error_upper_bound" => 0,
                                          "sum_other_doc_count" => 0,
                                          "buckets" =>
                                            [{ "key" => "Modèle par défaut", "doc_count" => 119 },
                                             { "key" => "Blanc", "doc_count" => 6 },
                                             { "key" => "Beige", "doc_count" => 3 },
                                             { "key" => "Bleu", "doc_count" => 3 },
                                             { "key" => "Noir", "doc_count" => 3 },
                                             { "key" => "Rose", "doc_count" => 3 },
                                             { "key" => "Argent", "doc_count" => 2 },
                                             { "key" => "Rouge", "doc_count" => 2 },
                                             { "key" => "Vert", "doc_count" => 2 },
                                             { "key" => "doré", "doc_count" => 2 },
                                             { "key" => "or", "doc_count" => 2 },
                                             { "key" => "Air jordan", "doc_count" => 1 },
                                             { "key" => "Air jordan 4", "doc_count" => 1 },
                                             { "key" => "Argenté", "doc_count" => 1 },
                                             { "key" => "Bleu Vert", "doc_count" => 1 },
                                             { "key" => "Corail", "doc_count" => 1 },
                                             { "key" => "Cornaline", "doc_count" => 1 },
                                             { "key" => "Emeraude ", "doc_count" => 1 },
                                             { "key" => "Gris", "doc_count" => 1 },
                                             { "key" => "Gris bleuté ", "doc_count" => 1 },
                                             { "key" => "Jaune", "doc_count" => 1 },
                                             { "key" => "MARRON", "doc_count" => 1 },
                                             { "key" => "Mint", "doc_count" => 1 },
                                             { "key" => "Nuage Gold", "doc_count" => 1 },
                                             { "key" => "Orange", "doc_count" => 1 },
                                             { "key" => "Rose Poudré", "doc_count" => 1 },
                                             { "key" => "Rouge Thaï", "doc_count" => 1 },
                                             { "key" => "Turquoise", "doc_count" => 1 },
                                             { "key" => "Vert Thaï", "doc_count" => 1 },
                                             { "key" => "améthyste", "doc_count" => 1 },
                                             { "key" => "bleu clair", "doc_count" => 1 },
                                             { "key" => "bleu foncé", "doc_count" => 1 },
                                             { "key" => "fushia", "doc_count" => 1 },
                                             { "key" => "gris army", "doc_count" => 1 },
                                             { "key" => "vert-gris", "doc_count" => 1 }] } } }
          random_scored_response = Searchkick::Results.new(Product, searchkick_response, option)
          allow(::Requests::ProductSearches).to receive(:search_random_products).and_return(random_scored_response)
          post :search, params: { location: location.slug, q: "Savon", page: page }
          should respond_with(200)

          expect(response.body).to eq(Dto::V1::Product::Search::Response.create({ products: random_scored_response.map { |p| p }, aggs: random_scored_response.aggs, page: page }).to_h.to_json)

          JSON.parse(response.body)["products"].each do |product|
            expect(product).to_not be_nil
          end
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
