require "rails_helper"

RSpec.describe Dto::V1::Delivery::Response, type: :model do
  describe 'to_h' do
    context 'All ok' do
      it 'should return a hash representation of Dto::V1::Delivery::Response' do
        dto = Dto::V1::Delivery::Response.new({id: 4,
                                               name: 'Livraison',
                                               slug: 'livraison',
                                               description: 'description',
                                               public_description: 'public description',
                                               detailed_public_description: 'detailed public description',
                                               is_express: true,
                                               is_shop_dependent: true,
                                               is_delivery: true})
        result = dto.to_h

        expect(result).to be_instance_of(Hash)
        expect(result[:id]).to eq(dto.id)
        expect(result[:name]).to eq(dto.name)
        expect(result[:slug]).to eq(dto.slug)
        expect(result[:description]).to eq(dto.description)
        expect(result[:publicDescription]).to eq(dto.public_description)
        expect(result[:detailedPublicDescription]).to eq(dto.detailed_public_description)
        expect(result[:isExpress]).to eq(dto.is_express)
        expect(result[:isShopDependent]).to eq(dto.is_shop_dependent)
        expect(result[:isDelivery]).to eq(dto.is_delivery)
      end
    end
  end

  describe 'create' do
    context 'All ok' do
      it 'should return a Dto::V1::Delivery::Response' do
        delivery = create(:service)

        result = Dto::V1::Delivery::Response.create(delivery)

        expect(result).to be_instance_of(Dto::V1::Delivery::Response)
        expect(result.id).to eq(delivery.id)
        expect(result.name).to eq(delivery.name)
        expect(result.slug).to eq(delivery.slug)
        expect(result.description).to eq(delivery.description)
        expect(result.public_description).to eq(delivery.public_description)
        expect(result.detailed_public_description).to eq(delivery.detailed_public_description)
        expect(result.is_express).to eq(delivery.express)
        expect(result.is_shop_dependent).to eq(delivery.shop_dependent)
        expect(result.is_delivery).to eq(delivery.is_delivery)
      end
    end
  end
end
