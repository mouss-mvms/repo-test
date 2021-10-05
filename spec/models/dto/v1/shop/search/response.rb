require 'rails_helper'

RSpec.describe Dto::V1::Shop::Search::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Shop::Search::Response' do
        shop_search_result = {
          shops:
            [{ :_index => "shops_v1_20210314105410121",
               :_type => "_doc",
               :_id => "4223",
               :_score => nil,
               :id => "4223",
               :name => "Saveurs et Harmonie",
               :createdAt => "2020-04-27T20:14:44.770+02:00",
               :updatedAt => "2021-07-26T09:51:22.592+02:00",
               :slug => "saveurs-et-harmonie",
               :shopUrl => "/fr/toulouse/boutiques/saveurs-et-harmonie",
               :inHolidays => false,
               :categoryTreeIds => [2054, 2257, 2249, 2250, 2251],
               :categoryTreeNames => ["Alimentation", "Infusion bien-être", "Thé et infusion", "Thé noir", "Thé parfumé"],
               :baseline => nil,
               :description => nil,
               :brandsName => [""],
               :cityLabel => "Toulouse",
               :citySlug => "toulouse",
               :inseeCode => "31555",
               :territoryName => "Toulouse",
               :territorySlug => "toulouse",
               :departmentNumber => "31",
               :deletedAt => nil,
               :numberOfOnlineProducts => 5,
               :numberOfOrders => 4,
               :imageUrl =>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90775/file/thumb-ff6da91d1e3c4cbf9fe11312c1175942.jpg",
               :coupons =>
                 "[{\"id\":1100,\"label\":\"foo\",\"start_at\":\"2021-06-01\",\"end_at\":\"2021-09-30\",\"state\":\"active\",\"image_url\":\"https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/103008/file/06bed65f6992484f4ac9dcec3ea3f0a2.jpeg\"}]",
               :pictogramUrl => nil,
               :services =>
                 ["click-collect",
                  "livraison-par-le-commercant",
                  "livraison-par-colissimo",
                  "e-reservation",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste"],
               :isTemplate => false,
               :score => 4,
               :indexedAt => "2021-09-07T16:00:00.921+02:00" },
             { :_index => "shops_v1_20210314105410121",
               :_type => "_doc",
               :_id => "4146",
               :_score => nil,
               :id => "4146",
               :name => "iep-shoes.com",
               :createdAt => "2020-04-26T13:32:41.995+02:00",
               :updatedAt => "2021-05-06T17:16:00.275+02:00",
               :slug => "iep-shoes-com",
               :shopUrl => "/fr/toulouse/boutiques/iep-shoes-com",
               :inHolidays => false,
               :categoryTreeIds => [2878, 2885, 2835, 2836, 2879, 2889, 2881],
               :categoryTreeNames => ["Chaussures", "Ballerines", "Mode", "Femme", "Baskets", "Bottes", "Escarpins"],
               :baseline => nil,
               :description => nil,
               :brandsName => ["", "Tom et Eva", "Tom & Eva", "Chic Nana", "Ideal Shoes", "Lov'it"],
               :cityLabel => "Toulouse",
               :citySlug => "toulouse",
               :inseeCode => "31555",
               :territoryName => "Toulouse",
               :territorySlug => "toulouse",
               :departmentNumber => "31",
               :deletedAt => nil,
               :numberOfOnlineProducts => 8,
               :numberOfOrders => 1,
               :imageUrl => "default_box_shop.svg",
               :coupons => "[]",
               :pictogramUrl => nil,
               :services =>
                 ["e-reservation",
                  "click-collect",
                  "livraison-par-le-commercant",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste",
                  "livraison-par-colissimo"],
               :isTemplate => false,
               :score => 1,
               :indexedAt => "2021-09-03T13:43:51.546+02:00" }],
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
        result = ::Dto::V1::Shop::Search::Response.create(shop_search_result)

        expect(result).to be_instance_of(Dto::V1::Shop::Search::Response)
        expect(result.products).to be_instance_of(Array)
        result.shops.each do |product|
          expect(product).to be_instance_of(Dto::V1::ProductSummary::Response)
        end
        expect(result.filters).to be_instance_of(Dto::V1::Search::Filter::Response)
        expect(result.page).to eq(shop_search_result[:page])
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Product::Response' do
        shop_search_result = {
          shops:
            [{ :_index => "shops_v1_20210314105410121",
               :_type => "_doc",
               :_id => "4223",
               :_score => nil,
               :id => "4223",
               :name => "Saveurs et Harmonie",
               :createdAt => "2020-04-27T20:14:44.770+02:00",
               :updatedAt => "2021-07-26T09:51:22.592+02:00",
               :slug => "saveurs-et-harmonie",
               :shopUrl => "/fr/toulouse/boutiques/saveurs-et-harmonie",
               :inHolidays => false,
               :categoryTreeIds => [2054, 2257, 2249, 2250, 2251],
               :categoryTreeNames => ["Alimentation", "Infusion bien-être", "Thé et infusion", "Thé noir", "Thé parfumé"],
               :baseline => nil,
               :description => nil,
               :brandsName => [""],
               :cityLabel => "Toulouse",
               :citySlug => "toulouse",
               :inseeCode => "31555",
               :territoryName => "Toulouse",
               :territorySlug => "toulouse",
               :departmentNumber => "31",
               :deletedAt => nil,
               :numberOfOnlineProducts => 5,
               :numberOfOrders => 4,
               :imageUrl =>
                 "https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/90775/file/thumb-ff6da91d1e3c4cbf9fe11312c1175942.jpg",
               :coupons =>
                 "[{\"id\":1100,\"label\":\"foo\",\"start_at\":\"2021-06-01\",\"end_at\":\"2021-09-30\",\"state\":\"active\",\"image_url\":\"https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/103008/file/06bed65f6992484f4ac9dcec3ea3f0a2.jpeg\"}]",
               :pictogramUrl => nil,
               :services =>
                 ["click-collect",
                  "livraison-par-le-commercant",
                  "livraison-par-colissimo",
                  "e-reservation",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste"],
               :isTemplate => false,
               :score => 4,
               :indexedAt => "2021-09-07T16:00:00.921+02:00" },
             { :_index => "shops_v1_20210314105410121",
               :_type => "_doc",
               :_id => "4146",
               :_score => nil,
               :id => "4146",
               :name => "iep-shoes.com",
               :createdAt => "2020-04-26T13:32:41.995+02:00",
               :updatedAt => "2021-05-06T17:16:00.275+02:00",
               :slug => "iep-shoes-com",
               :shopUrl => "/fr/toulouse/boutiques/iep-shoes-com",
               :inHolidays => false,
               :categoryTreeIds => [2878, 2885, 2835, 2836, 2879, 2889, 2881],
               :categoryTreeNames => ["Chaussures", "Ballerines", "Mode", "Femme", "Baskets", "Bottes", "Escarpins"],
               :baseline => nil,
               :description => nil,
               :brandsName => ["", "Tom et Eva", "Tom & Eva", "Chic Nana", "Ideal Shoes", "Lov'it"],
               :cityLabel => "Toulouse",
               :citySlug => "toulouse",
               :inseeCode => "31555",
               :territoryName => "Toulouse",
               :territorySlug => "toulouse",
               :departmentNumber => "31",
               :deletedAt => nil,
               :numberOfOnlineProducts => 8,
               :numberOfOrders => 1,
               :imageUrl => "default_box_shop.svg",
               :coupons => "[]",
               :pictogramUrl => nil,
               :services =>
                 ["e-reservation",
                  "click-collect",
                  "livraison-par-le-commercant",
                  "livraison-express-par-stuart",
                  "livraison-par-la-poste",
                  "livraison-par-colissimo"],
               :isTemplate => false,
               :score => 1,
               :indexedAt => "2021-09-03T13:43:51.546+02:00" }],
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
        dto = Dto::V1::Shop::Search::Response.create(shop_search_result)

        dto_hash = dto.to_h
        expect(dto_hash[:products]).to eq(dto.products.map(&:to_h))
        expect(dto_hash[:filters]).to eq(dto.filters.to_h)
        expect(dto_hash[:page]).to eq(dto.page)
      end
    end
  end
end