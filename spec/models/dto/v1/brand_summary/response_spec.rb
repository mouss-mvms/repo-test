require "rails_helper"

RSpec.describe Dto::V1::BrandSummary::Response do
  describe "#create" do
    context "All ok" do
      it 'should return a Dto::V1::BrandSummary::Response' do
        brand_response = {
          "_index"=>"brands_v1_20211008170234192",
          "_type"=>"_doc",
          "_id"=>"2777",
          "_score"=>nil,
          "id"=>2777,
          "name"=>"OCP",
          "products_count"=>273,
          "indexed_at"=>"2021-10-08T15:02:38.979+00:00"
        }

        dto = Dto::V1::BrandSummary::Response.create(brand_response.deep_symbolize_keys)

        expect(dto).to be_instance_of(Dto::V1::BrandSummary::Response)
        expect(dto._index).to eq(brand_response["_index"])
        expect(dto._type).to eq(brand_response["_type"])
        expect(dto._id).to eq(brand_response["_id"])
        expect(dto._score).to eq(brand_response["_score"])
        expect(dto.id).to eq(brand_response["id"])
        expect(dto.name).to eq(brand_response["name"])
        expect(dto.products_count).to eq(brand_response["products_count"])
      end
    end
  end

  describe "to_h" do
    context "All ok" do
      it "should return a hash representation of Dto::V1::BrandSummary::Response" do
        brand_response = {
          "_index"=>"brands_v1_20211008170234192",
          "_type"=>"_doc",
          "_id"=>"2777",
          "_score"=>nil,
          "id"=>2777,
          "name"=>"OCP",
          "products_count"=>273,
          "indexed_at"=>"2021-10-08T15:02:38.979+00:00"
        }

        dto_hash = Dto::V1::BrandSummary::Response.create(brand_response.deep_symbolize_keys).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:_index]).to eq(brand_response["_index"])
        expect(dto_hash[:_type]).to eq(brand_response["_type"])
        expect(dto_hash[:_id]).to eq(brand_response["_id"])
        expect(dto_hash[:_score]).to eq(brand_response["_score"])
        expect(dto_hash[:id]).to eq(brand_response["id"])
        expect(dto_hash[:name]).to eq(brand_response["name"])
        expect(dto_hash[:productsCount]).to eq(brand_response["products_count"])
      end
    end
  end
end