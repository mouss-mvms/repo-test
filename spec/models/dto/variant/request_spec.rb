require "rails_helper"

RSpec.describe Dto::Variant::Request do
  describe 'create' do
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
      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::Variant::Request' do
        variant = create(:variant)
        variant_params = {
          start_at: variant.starts_at,
          end_at: variant.ends_at,
          discount: variant.discount,
        }

        dto_hash = Dto::GoodDeal::Request.new(variant_params).to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:start_at]).to eq(variant.starts_at)
        expect(dto_hash[:end_at]).to eq(variant.ends_at)
        expect(dto_hash[:discount]).to eq(variant.discount)
      end
    end
  end
end