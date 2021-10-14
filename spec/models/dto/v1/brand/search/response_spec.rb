require 'rails_helper'

RSpec.describe Dto::V1::Brand::Search::Response do

  describe '#create' do
    context 'All ok' do
      it 'should return a Dto::V1::Brand::Search::Response' do
        brand_search_response = {
          brands: [
            {
              "_index"=>"brands_v1_20211008170234192",
              "_type"=>"_doc",
              "_id"=>"2777",
              "_score"=>nil,
              "id"=>2777,
              "name"=>"OCP",
              "products_count"=>273,
              "indexed_at"=>"2021-10-08T15:02:38.979+00:00"
            },
            {
              "_index"=>"brands_v1_20211008170234192",
              "_type"=>"_doc",
              "_id"=>"319",
              "_score"=>nil,
              "id"=>319,
              "name"=>"Durex",
              "products_count"=>266,
              "indexed_at"=>"2021-10-08T15:02:34.855+00:00"
            }
          ],
          page: 2
        }

        dto = ::Dto::V1::Brand::Search::Response.create(brand_search_response)

        expect(dto).to be_an_instance_of(Dto::V1::Brand::Search::Response)
        expect(dto.brands).to be_instance_of(Array)
        expect(dto.brands.count).to eq(2)
        dto.brands.each do |brand|
          expect(brand).to be_an_instance_of(Dto::V1::BrandSummary::Response)
        end
        expect(dto.page).to eq(brand_search_response[:page])
      end
    end
  end

  describe "#to_h" do
    context "All ok" do
      it "should return a hash representation of Dto::V1::Brand::Search::Response" do
        brand_search_response = {
          brands: [
            {
              "_index"=>"brands_v1_20211008170234192",
              "_type"=>"_doc",
              "_id"=>"2777",
              "_score"=>nil,
              "id"=>2777,
              "name"=>"OCP",
              "products_count"=>273,
              "indexed_at"=>"2021-10-08T15:02:38.979+00:00"
            },
            {
              "_index"=>"brands_v1_20211008170234192",
              "_type"=>"_doc",
              "_id"=>"319",
              "_score"=>nil,
              "id"=>319,
              "name"=>"Durex",
              "products_count"=>266,
              "indexed_at"=>"2021-10-08T15:02:34.855+00:00"
            }
          ],
          page: 2
        }

        dto = ::Dto::V1::Brand::Search::Response.create(brand_search_response)
        dto_hash = dto.to_h

        expect(dto_hash).to be_an_instance_of(Hash)
        expect(dto_hash[:brands]).to eq(dto.brands.map(&:to_h))
        expect(dto_hash[:page]).to eq(dto.page)
      end
    end
  end
end
