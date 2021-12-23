require 'rails_helper'

RSpec.describe Dto::V1::Shop::Search::Response do
  describe "#create" do
    it 'should return a Dto::V1::Shop::Search::Response' do
      shop_search_results = {
        shops: [
          {
            "_index"=>"shops_v1_20211222083342709",
            "_type"=>"_doc",
            "_id"=>"238",
            "_score"=>nil,
            "sort"=> [
              "Le Comptoir du Bouteiller ",
              1640084633595
            ],
            "category_tree_names"=> [
              "Explicit",
              "Poppers",
              "Vin et spiritueux",
              "Vin",
              "Bordeaux",
              "Alimentation",
              "Epicerie sucrée",
              "Confiture",
              "Mode",
              "Homme",
              "Vêtements",
              "Jean",
              "Vallée de la Loire",
              "Vallée du Rhône",
              "Apéritif et spiritueux",
              "Apéritif sans alcool",
              "Alimentation Bébé",
              "Alimentation Toutou"
            ],
            "category_tree_ids"=> [
              3423,
              3427,
              2278,
              2279,
              2280,
              2054,
              2216,
              2221,
              2835,
              2923,
              2924,
              2929,
              2285,
              2283,
              2317,
              2331,
              2258,
              3429
            ],
            "services"=> [
              "e-reservation",
              "click-collect",
              "livraison-express-par-stuart",
              "diagana-youssouf",
              "livraison-test-1110",
              "livraison-par-colissimo",
              "ne-pas-toucher",
              "livraison-par-le-commercant"
            ],
            "territory_name"=> "Bordeaux",
            "territory_slug"=>"bordeaux",
            "brands_name"=> ["", "Michel Redde & Fils", "Comptoir des Confitures", "Château La Favière", "Domaine Jean Guiton"],
            "tag_names"=> ["maison", "Test flo delete", "reletag", "letagtest", "lorem", "Noël", "Belin"],
            "number_of_online_shopss"=>10,
            "average_price"=>9.28,
            "name"=>"Le Comptoir du Bouteiller ",
            "created_at"=>"2017-02-06T16:54:27.022+01:00",
            "updated_at"=>"2021-12-21T12:03:53.595+01:00",
            "slug"=>"comptoire-du-bouteiller",
            "shop_url"=>"/fr/bordeaux/boutiques/comptoire-du-bouteiller",
            "in_holidays"=>false, "baseline"=>"Un large choix de vins et spiritueux !",
            "description"=>"Quare hoc quidem praeceptum, cuiuscumque est, ad tollendam amicitiam valet; illud potius praecipiendum fuit, ut eam diligentiam adhiberemus in amicitiis comparandis, ut ne quando amare inciperemus eum, quem aliquando odisse possemus. Quin etiam si minus felices in diligendo fuissemus, ferendum id Scipio potius quam inimicitiarum tempus cogitandum putabat.\r\n\r\nQuibus ita sceleste patratis Paulus cruore perfusus reversusque ad principis castra multos coopertos paene catenis adduxit in squalorem deiectos atque maestitiam, quorum adventu intendebantur eculei uncosque parabat carnifex et tormenta. et ex is proscripti sunt plures actique in exilium alii, non nullos gladii consumpsere poenales. nec en",
            "deleted_at"=>nil,
            "number_of_orders"=>23,
            "image_url"=>"https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/6131/file/thumb-56a00f3d5c509aa4daf20d37f26f326e.jpg",
            "pictogram_url"=>nil,
            "is_template"=>false,
            "indexed_at"=>"2021-12-22T08:35:24.931+01:00",
            "promoted_at"=>"2021-12-08T16:15:12.021+01:00",
            "department_number"=>"33", "location"=> nil,
            "city_label"=>"Bordeaux",
            "city_slug"=>"bordeaux",
            "insee_code"=>"33063",
            "coupons"=>"[{\"id\":1109,\"label\":\"FOO\",\"start_at\":\"2021-12-07\",\"end_at\":\"2021-12-31\",\"state\":\"active\",\"image_url\":null}]",
            "score"=>26,
            "id"=>"238"
          }
        ],
        aggs: { "category_tree_ids" =>{
          "doc_count" => 13,
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
        page: 1,
        total_pages: 53,
        total_count: 2331
      }

      dto = Dto::V1::Shop::Search::Response.create(shop_search_results)
      expect(dto).to be_an_instance_of(Dto::V1::Shop::Search::Response)
      expect(dto.shops).to be_instance_of(Array)
      dto.shops.each do |shops|
        expect(shops).to be_instance_of(Dto::V1::ShopSummary::Response)
      end
      expect(dto.filters).to be_instance_of(Dto::V1::Search::Filter::Response)
      expect(dto.page).to eq(shop_search_results[:page])
      expect(dto.total_pages).to eq(shop_search_results[:total_pages])
      expect(dto.total_count).to eq(shop_search_results[:total_count])
    end
  end

  describe "#to_h" do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Product::Response' do
        shop_search_results = {
          shops: [
            {
              "_index"=>"shops_v1_20211222083342709",
              "_type"=>"_doc",
              "_id"=>"238",
              "_score"=>nil,
              "sort"=> [
                "Le Comptoir du Bouteiller ",
                1640084633595
              ],
              "category_tree_names"=> [
                "Explicit",
                "Poppers",
                "Vin et spiritueux",
                "Vin",
                "Bordeaux",
                "Alimentation",
                "Epicerie sucrée",
                "Confiture",
                "Mode",
                "Homme",
                "Vêtements",
                "Jean",
                "Vallée de la Loire",
                "Vallée du Rhône",
                "Apéritif et spiritueux",
                "Apéritif sans alcool",
                "Alimentation Bébé",
                "Alimentation Toutou"
              ],
              "category_tree_ids"=> [
                3423,
                3427,
                2278,
                2279,
                2280,
                2054,
                2216,
                2221,
                2835,
                2923,
                2924,
                2929,
                2285,
                2283,
                2317,
                2331,
                2258,
                3429
              ],
              "services"=> [
                "e-reservation",
                "click-collect",
                "livraison-express-par-stuart",
                "diagana-youssouf",
                "livraison-test-1110",
                "livraison-par-colissimo",
                "ne-pas-toucher",
                "livraison-par-le-commercant"
              ],
              "territory_name"=> "Bordeaux",
              "territory_slug"=>"bordeaux",
              "brands_name"=> ["", "Michel Redde & Fils", "Comptoir des Confitures", "Château La Favière", "Domaine Jean Guiton"],
              "tag_names"=> ["maison", "Test flo delete", "reletag", "letagtest", "lorem", "Noël", "Belin"],
              "number_of_online_shopss"=>10,
              "average_price"=>9.28,
              "name"=>"Le Comptoir du Bouteiller ",
              "created_at"=>"2017-02-06T16:54:27.022+01:00",
              "updated_at"=>"2021-12-21T12:03:53.595+01:00",
              "slug"=>"comptoire-du-bouteiller",
              "shop_url"=>"/fr/bordeaux/boutiques/comptoire-du-bouteiller",
              "in_holidays"=>false, "baseline"=>"Un large choix de vins et spiritueux !",
              "description"=>"Quare hoc quidem praeceptum, cuiuscumque est, ad tollendam amicitiam valet; illud potius praecipiendum fuit, ut eam diligentiam adhiberemus in amicitiis comparandis, ut ne quando amare inciperemus eum, quem aliquando odisse possemus. Quin etiam si minus felices in diligendo fuissemus, ferendum id Scipio potius quam inimicitiarum tempus cogitandum putabat.\r\n\r\nQuibus ita sceleste patratis Paulus cruore perfusus reversusque ad principis castra multos coopertos paene catenis adduxit in squalorem deiectos atque maestitiam, quorum adventu intendebantur eculei uncosque parabat carnifex et tormenta. et ex is proscripti sunt plures actique in exilium alii, non nullos gladii consumpsere poenales. nec en",
              "deleted_at"=>nil,
              "number_of_orders"=>23,
              "image_url"=>"https://mavillemonshopping-pages.s3.eu-west-1.amazonaws.com/uploads/development/image/6131/file/thumb-56a00f3d5c509aa4daf20d37f26f326e.jpg",
              "pictogram_url"=>nil,
              "is_template"=>false,
              "indexed_at"=>"2021-12-22T08:35:24.931+01:00",
              "promoted_at"=>"2021-12-08T16:15:12.021+01:00",
              "department_number"=>"33", "location"=> nil,
              "city_label"=>"Bordeaux",
              "city_slug"=>"bordeaux",
              "insee_code"=>"33063",
              "coupons"=>"[{\"id\":1109,\"label\":\"FOO\",\"start_at\":\"2021-12-07\",\"end_at\":\"2021-12-31\",\"state\":\"active\",\"image_url\":null}]",
              "score"=>26,
              "id"=>"238"
            }
          ],
          aggs: { "category_tree_ids" =>{
            "doc_count" => 13,
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
          page: 1,
          total_pages: 53,
          total_count: 2331
        }
        dto = Dto::V1::Shop::Search::Response.create(shop_search_results)

        dto_hash = dto.to_h
        expect(dto_hash[:shops]).to eq(dto.shops.map(&:to_h))
        expect(dto_hash[:filters]).to eq(dto.filters.to_h)
        expect(dto_hash[:page]).to eq(dto.page)
        expect(dto_hash[:totalPages]).to eq(dto.total_pages)
        expect(dto_hash[:totalCount]).to eq(dto.total_count)
      end
    end
  end
end
