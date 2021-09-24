require 'rails_helper'

RSpec.describe Dto::V1::Product::Search::Filter::Response do

  describe 'create' do
    context 'All ok without category' do
      let(:aggs) {
        {
          "category_tree_ids" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 2054, "doc_count" => 67 },
                 { "key" => 2835, "doc_count" => 57 },
                 { "key" => 2340, "doc_count" => 47 }
                ] },
          "sizes" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Taille unique", "doc_count" => 29 },
                 { "key" => "130 G", "doc_count" => 6 },
                 { "key" => "190 G", "doc_count" => 6 },
                 { "key" => "52", "doc_count" => 6 },
                 { "key" => "Bouteille 75cl", "doc_count" => 6 },
                 { "key" => "54", "doc_count" => 4 },
                 { "key" => "50", "doc_count" => 3 }] },
          "base_price" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 10.0, "doc_count" => 17 },
                 { "key" => 35.0, "doc_count" => 10 },
                 { "key" => 15.0, "doc_count" => 7 },
                 { "key" => 40.0, "doc_count" => 7 },
                 { "key" => 30.0, "doc_count" => 6 }
                ] },
          "brand_name" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "", "doc_count" => 131 },
                 { "key" => "OLIVIERS & CO", "doc_count" => 12 },
                 { "key" => "Dock des Epices", "doc_count" => 9 },
                 { "key" => "Mélanie Paolone", "doc_count" => 7 },
                 { "key" => "Green Heaven", "doc_count" => 6 },
                ] },
          "services" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "click-collect", "doc_count" => 291 },
                 { "key" => "e-reservation", "doc_count" => 291 },
                 { "key" => "livraison-express-par-stuart", "doc_count" => 291 },
                 { "key" => "livraison-par-colissimo", "doc_count" => 291 },
                 { "key" => "livraison-par-la-poste", "doc_count" => 290 },
                 { "key" => "livraison-par-le-commercant", "doc_count" => 33 },
                 { "key" => "livraison-de-proximite", "doc_count" => 6 }] },
          "colors" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Modèle par défaut", "doc_count" => 259 },
                 { "key" => "Blanc", "doc_count" => 8 },
                 { "key" => "Beige", "doc_count" => 3 },
                 { "key" => "Bleu", "doc_count" => 3 },
                 { "key" => "Jaune", "doc_count" => 3 },
                ] }
        }
      }

      it 'should return a Dto::V1::Product::Search::Filter::Response' do
        create(:category, id: 2054, name: "Alimentaire")
        create(:category, id: 2835, name: "PS5")
        create(:category, id: 2340, name: "Vetements")

        result = Dto::V1::Product::Search::Filter::Response.create(aggs)
        expect(result).to be_instance_of(Dto::V1::Product::Search::Filter::Response)

        expect(result.base_price).to be_instance_of(Array)
        expect(result.base_price).to eq(aggs["base_price"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.colors).to be_instance_of(Array)
        expect(result.colors).to eq(aggs["colors"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.sizes).to be_instance_of(Array)
        expect(result.sizes).to eq(aggs["sizes"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.services).to be_instance_of(Array)
        expect(result.services).to eq(aggs["services"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.brands).to be_instance_of(Array)
        expect(result.brands).to eq(aggs["brand_name"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.categories).to be_instance_of(Array)
        categories = Category.greatest.non_explicit
        counts = aggs['category_tree_ids']['buckets'].map { |c| c["key"] }
        categories = categories.map do |category|
          if counts.include?(category.id)
            { name: category.name, slugs: category.slug }
          end
        end.compact
        expect(result.categories).to eq(categories)
      end
    end

    context 'All ok with category' do
      let(:category_id) { 2054 }
      let(:aggs) {
        {
          "category_id" => category_id,
          "category_tree_ids" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 2054, "doc_count" => 67 },
                 { "key" => 2835, "doc_count" => 57 },
                 { "key" => 2340, "doc_count" => 47 }
                ] },
          "sizes" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Taille unique", "doc_count" => 29 },
                 { "key" => "130 G", "doc_count" => 6 },
                 { "key" => "190 G", "doc_count" => 6 },
                 { "key" => "52", "doc_count" => 6 },
                 { "key" => "Bouteille 75cl", "doc_count" => 6 },
                 { "key" => "54", "doc_count" => 4 },
                 { "key" => "50", "doc_count" => 3 }] },
          "base_price" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 10.0, "doc_count" => 17 },
                 { "key" => 35.0, "doc_count" => 10 },
                 { "key" => 15.0, "doc_count" => 7 },
                 { "key" => 40.0, "doc_count" => 7 },
                 { "key" => 30.0, "doc_count" => 6 }
                ] },
          "brand_name" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "", "doc_count" => 131 },
                 { "key" => "OLIVIERS & CO", "doc_count" => 12 },
                 { "key" => "Dock des Epices", "doc_count" => 9 },
                 { "key" => "Mélanie Paolone", "doc_count" => 7 },
                 { "key" => "Green Heaven", "doc_count" => 6 },
                ] },
          "services" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "click-collect", "doc_count" => 291 },
                 { "key" => "e-reservation", "doc_count" => 291 },
                 { "key" => "livraison-express-par-stuart", "doc_count" => 291 },
                 { "key" => "livraison-par-colissimo", "doc_count" => 291 },
                 { "key" => "livraison-par-la-poste", "doc_count" => 290 },
                 { "key" => "livraison-par-le-commercant", "doc_count" => 33 },
                 { "key" => "livraison-de-proximite", "doc_count" => 6 }] },
          "colors" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Modèle par défaut", "doc_count" => 259 },
                 { "key" => "Blanc", "doc_count" => 8 },
                 { "key" => "Beige", "doc_count" => 3 },
                 { "key" => "Bleu", "doc_count" => 3 },
                 { "key" => "Jaune", "doc_count" => 3 },
                ] }
        }
      }


      it 'should return a Dto::V1::Product::Search::Filter::Response' do
        category_1 = create(:category, id: category_id, name: "Alimentaire")
        create(:category, id: 2835, name: "PS5", parent_id: category_1.id)
        create(:category, id: 2340, name: "Vetements")

        result = Dto::V1::Product::Search::Filter::Response.create(aggs)
        expect(result).to be_instance_of(Dto::V1::Product::Search::Filter::Response)

        expect(result.base_price).to be_instance_of(Array)
        expect(result.base_price).to eq(aggs["base_price"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.colors).to be_instance_of(Array)
        expect(result.colors).to eq(aggs["colors"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.sizes).to be_instance_of(Array)
        expect(result.sizes).to eq(aggs["sizes"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.services).to be_instance_of(Array)
        expect(result.services).to eq(aggs["services"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.brands).to be_instance_of(Array)
        expect(result.brands).to eq(aggs["brand_name"]["buckets"].map { |item| { key: item["key"], value: item["doc_count"] } }.sort_by { |item| item[:value] }.reverse)

        expect(result.categories).to be_instance_of(Array)
        categories = Category.find(category_id).children
        counts = aggs['category_tree_ids']['buckets'].map { |c| c["key"] }
        categories = categories.map do |category|
          if counts.include?(category.id)
            { name: category.name, slugs: category.slug }
          end
        end.compact
        expect(result.categories).to eq(categories)
      end
    end
  end

  describe 'to_h' do
    context 'All ok without category' do
      let(:aggs) {
        {
          "category_tree_ids" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 2054, "doc_count" => 67 },
                 { "key" => 2835, "doc_count" => 57 },
                 { "key" => 2340, "doc_count" => 47 }
                ] },
          "sizes" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Taille unique", "doc_count" => 29 },
                 { "key" => "130 G", "doc_count" => 6 },
                 { "key" => "190 G", "doc_count" => 6 },
                 { "key" => "52", "doc_count" => 6 },
                 { "key" => "Bouteille 75cl", "doc_count" => 6 },
                 { "key" => "54", "doc_count" => 4 },
                 { "key" => "50", "doc_count" => 3 }] },
          "base_price" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => 10.0, "doc_count" => 17 },
                 { "key" => 35.0, "doc_count" => 10 },
                 { "key" => 15.0, "doc_count" => 7 },
                 { "key" => 40.0, "doc_count" => 7 },
                 { "key" => 30.0, "doc_count" => 6 }
                ] },
          "brand_name" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "", "doc_count" => 131 },
                 { "key" => "OLIVIERS & CO", "doc_count" => 12 },
                 { "key" => "Dock des Epices", "doc_count" => 9 },
                 { "key" => "Mélanie Paolone", "doc_count" => 7 },
                 { "key" => "Green Heaven", "doc_count" => 6 },
                ] },
          "services" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "click-collect", "doc_count" => 291 },
                 { "key" => "e-reservation", "doc_count" => 291 },
                 { "key" => "livraison-express-par-stuart", "doc_count" => 291 },
                 { "key" => "livraison-par-colissimo", "doc_count" => 291 },
                 { "key" => "livraison-par-la-poste", "doc_count" => 290 },
                 { "key" => "livraison-par-le-commercant", "doc_count" => 33 },
                 { "key" => "livraison-de-proximite", "doc_count" => 6 }] },
          "colors" =>
            { "doc_count" => 293,
              "doc_count_error_upper_bound" => 0,
              "sum_other_doc_count" => 0,
              "buckets" =>
                [{ "key" => "Modèle par défaut", "doc_count" => 259 },
                 { "key" => "Blanc", "doc_count" => 8 },
                 { "key" => "Beige", "doc_count" => 3 },
                 { "key" => "Bleu", "doc_count" => 3 },
                 { "key" => "Jaune", "doc_count" => 3 },
                ] }
        }
      }
      it 'should a hash representation of Dto::V1::Product::Search::Filter::Response' do
        dto = Dto::V1::Product::Search::Filter::Response.create(aggs)

        dto_hash = dto.to_h
        expect(dto_hash[:basePrice]).to eq(dto.base_price)
        expect(dto_hash[:colors]).to eq(dto.colors)
        expect(dto_hash[:sizes]).to eq(dto.sizes)
        expect(dto_hash[:services]).to eq(dto.services)
        expect(dto_hash[:categories]).to eq(dto.categories)
        expect(dto_hash[:brands]).to eq(dto.brands)
      end
    end
  end
end