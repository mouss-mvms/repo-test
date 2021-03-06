require 'rails_helper'

RSpec.describe Dto::V1::Variant::Response do

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Variant::Response' do
        image1 = create(:image, position: 0)
        image2 = create(:image, position: 1)
        api_provider = create(:api_provider, name: "wynd")
        reference = create(:reference, api_provider_variant: ApiProviderVariant.create(external_variant_id: 'trf67', api_provider: api_provider))
        reference.sample.images << image2
        reference.sample.images << image1
        result = Dto::V1::Variant::Response.create(reference)
        expect(result).to be_instance_of(Dto::V1::Variant::Response)
        expect(result.weight).to eq(reference.weight)
        expect(result.quantity).to eq(reference.quantity)
        result.images.each_with_index do |image_dto, index|
          expect(Image.find(image_dto.id).position).to eq(index)
          expect(image_dto).to be_instance_of(Dto::V1::Image::Response)
        end
        expect(result.base_price).to eq(reference.base_price)
        expect(result.is_default).to eq(reference.sample.default)
        expect(result.good_deal).to be_instance_of(Dto::V1::GoodDeal::Response)
        expect(result.characteristics).to be_instance_of(Array)
        expect(result.provider[:name]).to eq(reference.api_provider_variant.api_provider.name)
        expect(result.provider[:externalVariantId]).to eq(reference.api_provider_variant.external_variant_id)
      end

      context 'Variant has a good deal' do
        context 'Good deal is valid' do
          it 'should return a Dto::V1::Variant::Response with good deal property' do
            api_provider = create(:api_provider, name: "wynd")

            reference = create(:reference, good_deal: create(:good_deal, starts_at: (DateTime.now - 2), ends_at: (DateTime.now + 2)), api_provider_variant: ApiProviderVariant.create(external_variant_id: 'trf67', api_provider: api_provider))

            result = Dto::V1::Variant::Response.create(reference)
            expect(result).to be_instance_of(Dto::V1::Variant::Response)
            expect(result.weight).to eq(reference.weight)
            expect(result.quantity).to eq(reference.quantity)
            expect(result.images).to eq(reference.sample.images.map { |image| Dto::V1::Image::Response.new(image) })
            expect(result.base_price).to eq(reference.base_price)
            expect(result.is_default).to eq(reference.sample.default)
            expect(result.good_deal).to be_instance_of(Dto::V1::GoodDeal::Response)
            expect(result.characteristics).to be_instance_of(Array)
            expect(result.provider[:name]).to eq(reference.api_provider_variant.api_provider.name)
            expect(result.provider[:externalVariantId]).to eq(reference.api_provider_variant.external_variant_id)
          end
        end

        context 'Good deal starts after the date' do
          it 'should return a Dto::V1::Variant::Response with good deal property to nil' do
            api_provider = create(:api_provider, name: "wynd")

            reference = create(:reference, good_deal: create(:good_deal, starts_at: (DateTime.now + 2), ends_at: (DateTime.now + 4)), api_provider_variant: ApiProviderVariant.create(external_variant_id: 'trf67', api_provider: api_provider))

            result = Dto::V1::Variant::Response.create(reference)
            expect(result).to be_instance_of(Dto::V1::Variant::Response)
            expect(result.weight).to eq(reference.weight)
            expect(result.quantity).to eq(reference.quantity)
            expect(result.images).to eq(reference.sample.images.map { |image| Dto::V1::Image::Response.new(image) })
            expect(result.base_price).to eq(reference.base_price)
            expect(result.is_default).to eq(reference.sample.default)
            expect(result.good_deal).to be_nil
            expect(result.characteristics).to be_instance_of(Array)
            expect(result.provider[:name]).to eq(reference.api_provider_variant.api_provider.name)
            expect(result.provider[:externalVariantId]).to eq(reference.api_provider_variant.external_variant_id)
          end
        end

        context 'Good deal ends before the date' do
          it 'should return a Dto::V1::Variant::Response with good deal property to nil' do
            api_provider = create(:api_provider, name: "wynd")

            reference = create(:reference, good_deal: create(:good_deal, starts_at: (DateTime.now - 4), ends_at: (DateTime.now - 1)), api_provider_variant: ApiProviderVariant.create(external_variant_id: 'trf67', api_provider: api_provider))

            result = Dto::V1::Variant::Response.create(reference)
            expect(result).to be_instance_of(Dto::V1::Variant::Response)
            expect(result.weight).to eq(reference.weight)
            expect(result.quantity).to eq(reference.quantity)
            expect(result.images).to eq(reference.sample.images.map { |image| Dto::V1::Image::Response.new(image) })
            expect(result.base_price).to eq(reference.base_price)
            expect(result.is_default).to eq(reference.sample.default)
            expect(result.good_deal).to be_nil
            expect(result.characteristics).to be_instance_of(Array)
            expect(result.provider[:name]).to eq(reference.api_provider_variant.api_provider.name)
            expect(result.provider[:externalVariantId]).to eq(reference.api_provider_variant.external_variant_id)
          end
        end
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Variant::Response' do
        api_provider = create(:api_provider, name: "wynd")
        reference = create(:reference, api_provider_variant: ApiProviderVariant.create(external_variant_id: 'trf67', api_provider: api_provider))
        dto = Dto::V1::Variant::Response.create(reference)
        dto_hash = dto.to_h

        expect(dto_hash[:id]).to eq(dto.id)
        expect(dto_hash[:basePrice]).to eq(dto.base_price)
        expect(dto_hash[:weight]).to eq(dto.weight)
        expect(dto_hash[:quantity]).to eq(dto.quantity)
        expect(dto_hash[:images]).to eq(dto.images.map(&:to_h))
        expect(dto_hash[:isDefault]).to eq(dto.is_default)
        expect(dto_hash[:goodDeal]).to eq(dto.good_deal.to_h)
        expect(dto_hash[:provider][:name]).to eq(dto.provider[:name])
        expect(dto_hash[:provider][:externalVariantId]).to eq(dto.provider[:externalVariantId])
        expect(dto_hash[:characteristics]).to eq(dto.characteristics&.map { |characteristic| characteristic.to_h })
      end
    end
  end
end