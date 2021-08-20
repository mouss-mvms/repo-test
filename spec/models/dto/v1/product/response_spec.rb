require 'rails_helper'

RSpec.describe Dto::V1::Product::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Product::Response' do
        product = create(:product_created_by_citizen)
        result = Dto::V1::Product::Response.create(product)

        expect(result).to be_instance_of(Dto::V1::Product::Response)
        expect(result.id).to eq(product.id)
        expect(result.name).to eq(product.name)
        expect(result.description).to eq(product.description)
        expect(result.slug).to eq(product.slug)
        expect(result.brand).to eq(product&.brand&.name)
        expect(result.status).to eq(product.status)
        expect(result.is_service).to eq(product.is_a_service)
        expect(result.seller_advice).to eq(product.pro_advice)
        expect(result.image_urls).to eq(product.images.map(&:file_url))
        expect(result.category).to be_instance_of(Dto::V1::Category::Response)
        expect(result.variants).to eq(product.references&.map { |reference| Dto::V1::Variant::Response.create(reference) })
        expect(result.citizen_advice).to eq(product.advice&.content)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Product::Response' do
        product = create(:product_created_by_citizen)
        dto = Dto::V1::Product::Response.create(product)

        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:name]).to eq(dto.name)
        expect(dto_hash[:slug]).to eq(dto.slug)
        expect(dto_hash[:description]).to eq(dto.description)
        expect(dto_hash[:category]).to eq(dto.category.to_h)
        expect(dto_hash[:brand]).to eq(dto.brand)
        expect(dto_hash[:status]).to eq(dto.status)
        expect(dto_hash[:imageUrls]).to eq(dto.image_urls)
        expect(dto_hash[:sellerAdvice]).to eq(dto.seller_advice)
        expect(dto_hash[:isService]).to eq(dto.is_service)
        expect(dto_hash[:variants]).to eq(dto.variants&.map { |variant| variant.to_h })
        expect(dto_hash[:citizenAdvice]).to eq(dto.citizen_advice)
      end
    end
  end
end