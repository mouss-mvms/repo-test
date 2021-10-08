require 'rails_helper'

RSpec.describe Dto::V1::Brand::Response do
  describe "#create" do
    context 'All ok' do
      it "should return a Dto::V1::Brand::Response" do
        brand = create(:brand)
        result = Dto::V1::Brand::Response.create(brand: brand)

        expect(result).to be_instance_of(Dto::V1::Brand::Response)
        expect(result.id).to eq(brand.id)
        expect(result.name).to eq(brand.name)
      end
    end
  end

  describe "#to_h" do
    context "All ok" do
      it "should return a hash representation of Dto::V1::Brand::Response" do
        brand = create(:brand)
        dto_hash = Dto::V1::Brand::Response.create(brand: brand).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:id]).to eq(brand.id)
        expect(dto_hash[:name]).to eq(brand.name)
      end
    end
  end
end