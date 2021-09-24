require 'rails_helper'

RSpec.describe Dto::V1::Product::Search::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Product::Search::Response' do
        product_search_result = {
          products:
            [
              { "_index" => "products_v1_20210315162727103",
               "_type" => "_doc",
               "_id" => "40951",
               "_score" => 0.8413999,
               "id" => 40951,
               "name" => "Sneakers",
               "slug" => "sneakers-1",
               "created_at" => "2020-04-26T23:51:55.724+02:00",
               "updated_at" => "2020-04-26T23:51:57.120+02:00",
               "description" =>
                 "Sneakers de tous les looks, ces baskets femme vous accompagneront à la ville comme à la campagne. Avec leur dessus en textile structuré, leur fermeture à lacets très féminine et leur semelle antidérapante, elles ont le mérite d'être à la fois belles et confortables !\r\nDisponible du 36 au 41\r\nDétails produit\r\n    Talon plat\r\n    Fermeture : A lacets\r\n    Finition : Structuré et bordures lisse\r\n    Type de motif: Imprimé serpent\r\n    Caractéristique: Lacets Fantaisie\r\n    Vendu par : Paire\r\n    Couleur : Nude\r\nComposition et Entretien\r\n       •  Dessus/Tige : 100% cuir de vachette\r\n       •  Doublure : 100% coton\r\n       •  Semelle intérieure : 100% coton\r\n       •  Semelle extérieure : 100% caoutchouc",
               "base_price" => 39.95,
               "good_deal_starts_at" => "2020-04-26T00:00:00.000+02:00",
               "good_deal_ends_at" => "2020-04-26T23:59:59.999+02:00",
               "price" => 39.95,
               "quantity" => 1,
               "category_id" => 2879,
               "category_tree_names" => ["Chaussures", "Mode", "Baskets", "Femme"],
               "category_tree_ids" => [2878, 2835, 2879, 2836],
               "status" => "online",
               "shop_name" => "iep-shoes.com",
               "shop_id" => 4146,
               "shop_slug" => "iep-shoes-com",
               "in_holidays" => false,
               "brand_name" => "Tom & Eva",
               "brand_id" => 7396,
               "city_name" => "Toulouse",
               "city_label" => "Toulouse",
               "city_slug" => "toulouse",
               "conurbation_slug" => "toulouse",
               "insee_code" => "31555",
               "territory_name" => "Toulouse",
               "territory_slug" => "toulouse",
               "department_number" => "31",
               "product_citizen_nickname" => nil,
               "product_citizen_slug" => nil,
               "product_citizen_image_path" => nil,
               "default_sample_id" => 49160,
               "shop_pictogram_url" => "img_default_product.jpg",
               "image_url" =>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/88808/file/thumb-f3f3233ec9059a58bd200b897ce14c52.jpg",
               "product_page_url" =>
                 "https://mavillemonshopping-dev.herokuapp.com/fr/toulouse/iep-shoes-com/mode/femme/chaussures/baskets/produits/sneakers-1",
               "shop_url" => "/fr/toulouse/boutiques/iep-shoes-com",
               "number_of_orders" => 0,
               "colors" => ["Modèle par défaut"],
               "sizes" => ["36", "37", "38", "39", "40", "41"],
               "selection_ids" => [],
               "services" =>
                 ["e-reservation",
                  "click-collect",
                  "livraison-par-le-commercant",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste",
                  "livraison-par-colissimo"],
               "shop_is_template" => false,
               "score" => 0,
               "position" => nil,
               "indexed_at" => "2021-09-03T13:44:33.061+02:00",
               "unique_reference_id" => nil,
               "is_a_service" => nil },
              { "_index" => "products_v1_20210315162727103",
               "_type" => "_doc",
               "_id" => "41782",
               "_score" => 0.80631375,
               "id" => 41782,
               "name" => "Thé noir Earl Grey",
               "slug" => "the-noir-earl-grey",
               "created_at" => "2020-04-27T20:34:53.064+02:00",
               "updated_at" => "2020-04-27T20:34:53.604+02:00",
               "description" =>
                 "Le thé noir parfumé Grand Earl Grey est  un thé à la bergamote (agrume\"citrus bergamia\") qui fournit une fraic
          heur intense à la tasse et tonifie dès le réveil. Ceci depuis que le comte Grey l'adapta d'une recette chinoise.",
               "base_price" => 7.3,
               "good_deal_starts_at" => "2020-04-27T00:00:00.000+02:00",
               "good_deal_ends_at" => "2020-04-27T23:59:59.999+02:00",
               "price" => 7.3,
               "quantity" => 100,
               "category_id" => 2251,
               "category_tree_names" => ["Alimentation", "Thé et infusion", "Thé parfumé"],
               "category_tree_ids" => [2054, 2249, 2251],
               "status" => "online",
               "shop_name" => "Saveurs et Harmonie",
               "shop_id" => 4223,
               "shop_slug" => "saveurs-et-harmonie",
               "in_holidays" => false,
               "brand_name" => "",
               "brand_id" => 5,
               "city_name" => "Toulouse",
               "city_label" => "Toulouse",
               "city_slug" => "toulouse",
               "conurbation_slug" => "toulouse",
               "insee_code" => "31555",
               "territory_name" => "Toulouse",
               "territory_slug" => "toulouse",
               "department_number" => "31",
               "product_citizen_nickname" => nil,
               "product_citizen_slug" => nil,
               "product_citizen_image_path" => nil,
               "default_sample_id" => 50191,
               "shop_pictogram_url" =>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90775/file/thumb-ff6da91d1
          e3c4cbf9fe11312c1175942.jpg",
               "image_url" =>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90792/file/thumb-af22e5b63
          e8006126b1df249709f6d77.jpg",
               "product_page_url" =>
                 "https://mavillemonshopping-dev.herokuapp.com/fr/toulouse/saveurs-et-harmonie/alimentation/the-et-infusion/the-pa
          rfume/produits/the-noir-earl-grey",
               "shop_url" => "/fr/toulouse/boutiques/saveurs-et-harmonie",
               "number_of_orders" => 0,
               "colors" => ["Modèle par défaut"],
               "sizes" => [],
               "selection_ids" => [],
               "services" =>
                 ["click-collect",
                  "livraison-par-le-commercant",
                  "livraison-par-colissimo",
                  "e-reservation",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste"],
               "shop_is_template" => false,
               "score" => 0,
               "position" => nil,
               "indexed_at" => "2021-09-07T16:00:01.366+02:00",
               "unique_reference_id" => 92619,
               "is_a_service" => nil }
            ],
          aggs:
            { "category_tree_ids" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => 2835, "doc_count" => 9 },
                     { "key" => 2836, "doc_count" => 7 },
                     { "key" => 2878, "doc_count" => 7 },
                     { "key" => 2054, "doc_count" => 4 },
                     { "key" => 2249, "doc_count" => 4 },
                     { "key" => 2879, "doc_count" => 3 },
                     { "key" => 2250, "doc_count" => 2 },
                     { "key" => 2889, "doc_count" => 2 },
                     { "key" => 2923, "doc_count" => 2 },
                     { "key" => 2954, "doc_count" => 2 },
                     { "key" => 2955, "doc_count" => 2 },
                     { "key" => 2251, "doc_count" => 1 },
                     { "key" => 2257, "doc_count" => 1 },
                     { "key" => 2881, "doc_count" => 1 },
                     { "key" => 2885, "doc_count" => 1 }] },
              "sizes" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "37", "doc_count" => 7 },
                     { "key" => "38", "doc_count" => 7 },
                     { "key" => "39", "doc_count" => 7 },
                     { "key" => "40", "doc_count" => 6 },
                     { "key" => "41", "doc_count" => 6 },
                     { "key" => "36", "doc_count" => 5 }] },
              "base_price" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => 39.95000076293945, "doc_count" => 6 },
                     { "key" => 6.199999809265137, "doc_count" => 1 },
                     { "key" => 6.300000190734863, "doc_count" => 1 },
                     { "key" => 7.099999904632568, "doc_count" => 1 },
                     { "key" => 7.300000190734863, "doc_count" => 1 },
                     { "key" => 42.95000076293945, "doc_count" => 1 },
                     { "key" => 129.0, "doc_count" => 1 },
                     { "key" => 139.0, "doc_count" => 1 }] },
              "brand_name" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "", "doc_count" => 5 },
                     { "key" => "Tom & Eva", "doc_count" => 3 },
                     { "key" => "Chic Nana", "doc_count" => 1 },
                     { "key" => "Ideal Shoes", "doc_count" => 1 },
                     { "key" => "Lov'it", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN ", "doc_count" => 1 }] },
              "services" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "click-collect", "doc_count" => 13 },
                     { "key" => "e-reservation", "doc_count" => 13 },
                     { "key" => "livraison-express-par-stuart", "doc_count" => 13 },
                     { "key" => "livraison-par-colissimo", "doc_count" => 13 },
                     { "key" => "livraison-par-la-poste", "doc_count" => 13 },
                     { "key" => "livraison-par-le-commercant", "doc_count" => 13 }] },
              "colors" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" => [{ "key" => "Modèle par défaut", "doc_count" => 13 }] } },
          page: 2
        }
        result = ::Dto::V1::Product::Search::Response.create(product_search_result)

        expect(result).to be_instance_of(Dto::V1::Product::Search::Response)
        expect(result.products).to be_instance_of(Array)
        result.products.each do |product|
          expect(product).to be_instance_of(Dto::V1::ProductSummary::Response)
        end
        expect(result.filters).to be_instance_of(Dto::V1::Product::Search::Filter::Response)
        expect(result.page).to eq(product_search_result[:page])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Product::Response' do
        product_search_result = {
          products:
            [
              { "_index" => "products_v1_20210315162727103",
                "_type" => "_doc",
                "_id" => "40951",
                "_score" => 0.8413999,
                "id" => 40951,
                "name" => "Sneakers",
                "slug" => "sneakers-1",
                "created_at" => "2020-04-26T23:51:55.724+02:00",
                "updated_at" => "2020-04-26T23:51:57.120+02:00",
                "description" =>
                  "Sneakers de tous les looks, ces baskets femme vous accompagneront à la ville comme à la campagne. Avec leur dessus en textile structuré, leur fermeture à lacets très féminine et leur semelle antidérapante, elles ont le mérite d'être à la fois belles et confortables !\r\nDisponible du 36 au 41\r\nDétails produit\r\n    Talon plat\r\n    Fermeture : A lacets\r\n    Finition : Structuré et bordures lisse\r\n    Type de motif: Imprimé serpent\r\n    Caractéristique: Lacets Fantaisie\r\n    Vendu par : Paire\r\n    Couleur : Nude\r\nComposition et Entretien\r\n       •  Dessus/Tige : 100% cuir de vachette\r\n       •  Doublure : 100% coton\r\n       •  Semelle intérieure : 100% coton\r\n       •  Semelle extérieure : 100% caoutchouc",
                "base_price" => 39.95,
                "good_deal_starts_at" => "2020-04-26T00:00:00.000+02:00",
                "good_deal_ends_at" => "2020-04-26T23:59:59.999+02:00",
                "price" => 39.95,
                "quantity" => 1,
                "category_id" => 2879,
                "category_tree_names" => ["Chaussures", "Mode", "Baskets", "Femme"],
                "category_tree_ids" => [2878, 2835, 2879, 2836],
                "status" => "online",
                "shop_name" => "iep-shoes.com",
                "shop_id" => 4146,
                "shop_slug" => "iep-shoes-com",
                "in_holidays" => false,
                "brand_name" => "Tom & Eva",
                "brand_id" => 7396,
                "city_name" => "Toulouse",
                "city_label" => "Toulouse",
                "city_slug" => "toulouse",
                "conurbation_slug" => "toulouse",
                "insee_code" => "31555",
                "territory_name" => "Toulouse",
                "territory_slug" => "toulouse",
                "department_number" => "31",
                "product_citizen_nickname" => nil,
                "product_citizen_slug" => nil,
                "product_citizen_image_path" => nil,
                "default_sample_id" => 49160,
                "shop_pictogram_url" => "img_default_product.jpg",
                "image_url" =>
                  "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/88808/file/thumb-f3f3233ec9059a58bd200b897ce14c52.jpg",
                "product_page_url" =>
                  "https://mavillemonshopping-dev.herokuapp.com/fr/toulouse/iep-shoes-com/mode/femme/chaussures/baskets/produits/sneakers-1",
                "shop_url" => "/fr/toulouse/boutiques/iep-shoes-com",
                "number_of_orders" => 0,
                "colors" => ["Modèle par défaut"],
                "sizes" => ["36", "37", "38", "39", "40", "41"],
                "selection_ids" => [],
                "services" =>
                  ["e-reservation",
                   "click-collect",
                   "livraison-par-le-commercant",
                   "livraison-express-par-stuart",
                   "livraison-par-la-poste",
                   "livraison-par-colissimo"],
                "shop_is_template" => false,
                "score" => 0,
                "position" => nil,
                "indexed_at" => "2021-09-03T13:44:33.061+02:00",
                "unique_reference_id" => nil,
                "is_a_service" => nil },
              { "_index" => "products_v1_20210315162727103",
                "_type" => "_doc",
                "_id" => "41782",
                "_score" => 0.80631375,
                "id" => 41782,
                "name" => "Thé noir Earl Grey",
                "slug" => "the-noir-earl-grey",
                "created_at" => "2020-04-27T20:34:53.064+02:00",
                "updated_at" => "2020-04-27T20:34:53.604+02:00",
                "description" =>
                  "Le thé noir parfumé Grand Earl Grey est  un thé à la bergamote (agrume\"citrus bergamia\") qui fournit une fraic
          heur intense à la tasse et tonifie dès le réveil. Ceci depuis que le comte Grey l'adapta d'une recette chinoise.",
                "base_price" => 7.3,
                "good_deal_starts_at" => "2020-04-27T00:00:00.000+02:00",
                "good_deal_ends_at" => "2020-04-27T23:59:59.999+02:00",
                "price" => 7.3,
                "quantity" => 100,
                "category_id" => 2251,
                "category_tree_names" => ["Alimentation", "Thé et infusion", "Thé parfumé"],
                "category_tree_ids" => [2054, 2249, 2251],
                "status" => "online",
                "shop_name" => "Saveurs et Harmonie",
                "shop_id" => 4223,
                "shop_slug" => "saveurs-et-harmonie",
                "in_holidays" => false,
                "brand_name" => "",
                "brand_id" => 5,
                "city_name" => "Toulouse",
                "city_label" => "Toulouse",
                "city_slug" => "toulouse",
                "conurbation_slug" => "toulouse",
                "insee_code" => "31555",
                "territory_name" => "Toulouse",
                "territory_slug" => "toulouse",
                "department_number" => "31",
                "product_citizen_nickname" => nil,
                "product_citizen_slug" => nil,
                "product_citizen_image_path" => nil,
                "default_sample_id" => 50191,
                "shop_pictogram_url" =>
                  "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90775/file/thumb-ff6da91d1
          e3c4cbf9fe11312c1175942.jpg",
                "image_url" =>
                  "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90792/file/thumb-af22e5b63
          e8006126b1df249709f6d77.jpg",
                "product_page_url" =>
                  "https://mavillemonshopping-dev.herokuapp.com/fr/toulouse/saveurs-et-harmonie/alimentation/the-et-infusion/the-pa
          rfume/produits/the-noir-earl-grey",
                "shop_url" => "/fr/toulouse/boutiques/saveurs-et-harmonie",
                "number_of_orders" => 0,
                "colors" => ["Modèle par défaut"],
                "sizes" => [],
                "selection_ids" => [],
                "services" =>
                  ["click-collect",
                   "livraison-par-le-commercant",
                   "livraison-par-colissimo",
                   "e-reservation",
                   "livraison-express-par-stuart",
                   "livraison-par-la-poste"],
                "shop_is_template" => false,
                "score" => 0,
                "position" => nil,
                "indexed_at" => "2021-09-07T16:00:01.366+02:00",
                "unique_reference_id" => 92619,
                "is_a_service" => nil }
            ],
          aggs:
            { "category_tree_ids" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => 2835, "doc_count" => 9 },
                     { "key" => 2836, "doc_count" => 7 },
                     { "key" => 2878, "doc_count" => 7 },
                     { "key" => 2054, "doc_count" => 4 },
                     { "key" => 2249, "doc_count" => 4 },
                     { "key" => 2879, "doc_count" => 3 },
                     { "key" => 2250, "doc_count" => 2 },
                     { "key" => 2889, "doc_count" => 2 },
                     { "key" => 2923, "doc_count" => 2 },
                     { "key" => 2954, "doc_count" => 2 },
                     { "key" => 2955, "doc_count" => 2 },
                     { "key" => 2251, "doc_count" => 1 },
                     { "key" => 2257, "doc_count" => 1 },
                     { "key" => 2881, "doc_count" => 1 },
                     { "key" => 2885, "doc_count" => 1 }] },
              "sizes" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "37", "doc_count" => 7 },
                     { "key" => "38", "doc_count" => 7 },
                     { "key" => "39", "doc_count" => 7 },
                     { "key" => "40", "doc_count" => 6 },
                     { "key" => "41", "doc_count" => 6 },
                     { "key" => "36", "doc_count" => 5 }] },
              "base_price" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => 39.95000076293945, "doc_count" => 6 },
                     { "key" => 6.199999809265137, "doc_count" => 1 },
                     { "key" => 6.300000190734863, "doc_count" => 1 },
                     { "key" => 7.099999904632568, "doc_count" => 1 },
                     { "key" => 7.300000190734863, "doc_count" => 1 },
                     { "key" => 42.95000076293945, "doc_count" => 1 },
                     { "key" => 129.0, "doc_count" => 1 },
                     { "key" => 139.0, "doc_count" => 1 }] },
              "brand_name" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "", "doc_count" => 5 },
                     { "key" => "Tom & Eva", "doc_count" => 3 },
                     { "key" => "Chic Nana", "doc_count" => 1 },
                     { "key" => "Ideal Shoes", "doc_count" => 1 },
                     { "key" => "Lov'it", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN", "doc_count" => 1 },
                     { "key" => "SEMERDJIAN ", "doc_count" => 1 }] },
              "services" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" =>
                    [{ "key" => "click-collect", "doc_count" => 13 },
                     { "key" => "e-reservation", "doc_count" => 13 },
                     { "key" => "livraison-express-par-stuart", "doc_count" => 13 },
                     { "key" => "livraison-par-colissimo", "doc_count" => 13 },
                     { "key" => "livraison-par-la-poste", "doc_count" => 13 },
                     { "key" => "livraison-par-le-commercant", "doc_count" => 13 }] },
              "colors" =>
                { "doc_count" => 13,
                  "doc_count_error_upper_bound" => 0,
                  "sum_other_doc_count" => 0,
                  "buckets" => [{ "key" => "Modèle par défaut", "doc_count" => 13 }] } },
          page: 2
        }
        dto = Dto::V1::Product::Search::Response.create(product_search_result)

        dto_hash = dto.to_h
        expect(dto_hash[:products]).to eq(dto.products.map(&:to_h))
        expect(dto_hash[:filters]).to eq(dto.filters.to_h)
        expect(dto_hash[:page]).to eq(dto.page)
      end
    end
  end
end