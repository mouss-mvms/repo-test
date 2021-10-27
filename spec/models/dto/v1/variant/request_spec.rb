require "rails_helper"

RSpec.describe Dto::V1::Variant::Request do
  describe 'new' do
    context 'All ok' do
      it 'should return a Dto::Variant::Request' do
        variant_params =             {
          base_price: 20.5,
          weight: 20.5,
          quantity: 20,
          is_default: false,
          good_deal: {
            start_at: "20/01/2021",
            end_at: "16/02/2021",
            discount: "20"
          },
          characteristics: [
            {
              name: "color",
              value: "blue"
            },
            {
                name: "size",
                value: "S"
            }
          ],
          external_variant_id: 'tr56'
        }

        dto_variant = Dto::V1::Variant::Request.new(variant_params)

        expect(dto_variant).to be_instance_of(Dto::V1::Variant::Request)
        expect(dto_variant.base_price).to eq(variant_params[:base_price])
        expect(dto_variant.weight).to eq(variant_params[:weight])
        expect(dto_variant.quantity).to eq(variant_params[:quantity])
        expect(dto_variant.is_default).to eq(variant_params[:is_default])
        expect(dto_variant.good_deal).to be_instance_of(Dto::V1::GoodDeal::Request)
        expect(dto_variant.characteristics.count).to eq(variant_params[:characteristics].count)
        expect(dto_variant.external_variant_id).to eq(variant_params[:external_variant_id])
        dto_variant.characteristics.each do |c|
          expect(c).to be_instance_of(Dto::V1::Characteristic::Request)
        end

      end
    end
  end

  describe 'to_h' do
    context 'All ok' do
      it 'should a hash representation of Dto::V1::Variant::Request' do
        variant_params = {
          base_price: 20.5,
          weight: 20.5,
          quantity: 20,
          is_default: false,
          good_deal: {
            start_at: "20/01/2021",
            end_at: "16/02/2021",
            discount: "20"
          },
          characteristics: [
            {
              name: "color",
              value: "blue"
            },
            {
                name: "size",
                value: "S"
            }
          ],
          external_variant_id: 'tr56'
        }

        dto_variant = Dto::V1::Variant::Request.new(variant_params)
        dto_hash = dto_variant.to_h

        expect(dto_hash).to be_instance_of(Hash)
        expect(dto_hash[:base_price]).to eq(dto_variant.base_price)
        expect(dto_hash[:weight]).to eq(dto_variant.weight)
        expect(dto_hash[:quantity]).to eq(dto_variant.quantity)
        expect(dto_hash[:is_default]).to eq(dto_variant.is_default)
        expect(dto_hash[:good_deal]).to eq(dto_variant.good_deal.to_h)
        expect(dto_hash[:characteristics].count).to eq(dto_variant.characteristics.count)
        expect(dto_hash[:external_variant_id]).to eq(dto_variant.external_variant_id)
      end
    end
  end
end