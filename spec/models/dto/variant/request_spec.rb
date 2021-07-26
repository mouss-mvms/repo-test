require "rails_helper"

RSpec.describe Dto::Variant::Request do
  describe 'new' do
    context 'All ok' do
      it 'should return a Dto::Variant::Request' do
        variant = create(:variant)
        variant_params = {
          base_price: variant.base_price,
          weight: variant.weight,
          quantity: variant.quantity,
          is_default: variant.is_default,
          good_deal: {
            start_at: variant.good_deal.starts_at,
            end_at: variant.good_deal.ends_at,
            discount: variant.good_deal.discount,
          },
          characteristics: variant.characteristics.map { |char| { name: char.name, value: char.value } }
        }

        result = Dto::Variant::Request.new(variant_params)

        expect(result).to be_instance_of(Dto::Variant::Request)
        expect(result.base_price).to eq(variant.base_price)
        expect(result.weight).to eq(variant.weight)
        expect(result.quantity).to eq(variant.quantity)
        expect(result.is_default).to eq(variant.is_default)
        expect(result.good_deal).to be_instance_of(Dto::GoodDeal::Request)
        expect(result.characteristics.count).to eq(variant.characteristics.count)
        result.characteristics.each do |c|
          expect(c).to be_instance_of(Dto::Characteristic::Request)
        end

      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Variant::Request' do
        variant = create(:variant)
        variant_params = {
          base_price: variant.base_price,
          weight: variant.weight,
          quantity: variant.quantity,
          is_default: variant.is_default,
          good_deal: {
            start_at: variant.good_deal.starts_at,
            end_at: variant.good_deal.ends_at,
            discount: variant.good_deal.discount,
          },
          characteristics: variant.characteristics.map { |char| { name: char.name, value: char.value } }
        }

        dto_hash = Dto::Variant::Request.new(variant_params).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:base_price]).to eq(variant.base_price)
        expect(dto_hash[:weight]).to eq(variant.weight)
        expect(dto_hash[:quantity]).to eq(variant.quantity)
        expect(dto_hash[:is_default]).to eq(variant.is_default)
        expect(dto_hash[:good_deal]).to be_instance_of(Hash)
        expect(dto_hash[:good_deal]).to eq(variant_params[:good_deal])
        expect(dto_hash[:characteristics].count).to eq(variant_params[:characteristics].count)
      end
    end
  end
end