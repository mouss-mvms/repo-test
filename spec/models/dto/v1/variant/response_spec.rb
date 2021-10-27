require 'rails_helper'

RSpec.describe Dto::V1::Variant::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Variant::Response' do
        reference = create(:reference, external_variant_id: 'trf67')
        result = Dto::V1::Variant::Response.create(reference)
        expect(result).to be_instance_of(Dto::V1::Variant::Response)
        expect(result.weight).to eq(reference.weight)
        expect(result.quantity).to eq(reference.quantity)
        expect(result.image_urls).to eq(reference.sample.images.map(&:file_url))
        expect(result.base_price).to eq(reference.base_price)
        expect(result.is_default).to eq(reference.sample.default)
        expect(result.good_deal).to be_instance_of(Dto::V1::GoodDeal::Response)
        expect(result.characteristics).to be_instance_of(Array)
        expect(result.external_variant_id).to eq(reference.external_variant_id)
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Variant::Response' do
        reference = create(:reference, external_variant_id: 'trf67')
        dto = Dto::V1::Variant::Response.create(reference)
        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:basePrice]).to eq(dto.base_price)
        expect(dto_hash[:weight]).to eq(dto.weight)
        expect(dto_hash[:quantity]).to eq(dto.quantity)
        expect(dto_hash[:imageUrls]).to eq(dto.image_urls)
        expect(dto_hash[:isDefault]).to eq(dto.is_default)
        expect(dto_hash[:goodDeal]).to eq(dto.good_deal.to_h)
        expect(dto_hash[:externalVariantId]).to eq(reference.external_variant_id)
        expect(dto_hash[:characteristics]).to eq(dto.characteristics&.map { |characteristic| characteristic.to_h })
      end
    end
  end
end