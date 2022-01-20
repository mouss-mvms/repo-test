require "rails_helper"

RSpec.describe Dao::Variant, :type => :model do
  context '#create' do
    it 'should create a variant' do
      api_provider = create(:api_provider, name: 'wynd')
      product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
      create_params =
        {
          base_price: 20.5,
          weight: 20.5,
          quantity: 20,
          is_default: false,
          image_urls: [
            "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
          ],
          good_deal: {
            start_at: "20/01/2021",
            end_at: "16/02/2021",
            discount: 20.0
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
          product_id: product.id,
          provider: {
            name: api_provider.name,
            external_variant_id: '56ty'
          }
        }

      dto_variant = Dto::V1::Variant::Request.new(create_params)
      reference = Dao::Variant.create(dto_variant_request: dto_variant)

      expect(reference.base_price).to eq(dto_variant.base_price)
      expect(reference.weight).to eq(dto_variant.weight)
      expect(reference.quantity).to eq(dto_variant.quantity)
      expect(reference.sample.default).to eq(dto_variant.is_default)
      expect(reference.sample.images).not_to be_empty
      expect(reference.sample.images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(reference.good_deal.starts_at.strftime("%d/%m/%Y")).to eq(dto_variant.good_deal.start_at)
      expect(reference.good_deal.discount).to eq(dto_variant.good_deal.discount)
      expect(reference.api_provider_variant.external_variant_id).to eq(dto_variant.provider[:external_variant_id])
      expect(reference.api_provider_variant.api_provider.name).to eq(dto_variant.provider[:name])
      characteristics = []
      characteristics << { name: 'color', value: reference.color.name }
      characteristics << { name: 'size', value: reference.size.name }
      characteristics.each do |charac|
        expect(dto_variant.characteristics.map(&:to_h)).to include(charac)
      end
    end
  end

  context '#update' do
    it 'should create a variant' do
      api_provider = create(:api_provider, name: 'wynd')
      product = create(:available_product, api_provider_product: ApiProviderProduct.create(external_product_id: 'trf67', api_provider: api_provider))
      reference = create(:reference, product: product)
      create_params =
        {
          id: reference.id,
          base_price: 20.5,
          weight: 20.5,
          quantity: 20,
          is_default: false,
          image_urls: [
            "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr"
          ],
          good_deal: {
            start_at: "20/01/2021",
            end_at: "16/02/2021",
            discount: 20.0
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
          product_id: product.id,
          provider: {
            name: api_provider.name,
            external_variant_id: '56ty'
          }
        }

      dto_variant = Dto::V1::Variant::Request.new(create_params)
      reference = Dao::Variant.update(dto_variant_request: dto_variant)

      expect(reference.base_price).to eq(dto_variant.base_price)
      expect(reference.weight).to eq(dto_variant.weight)
      expect(reference.quantity).to eq(dto_variant.quantity)
      expect(reference.sample.default).to eq(dto_variant.is_default)
      expect(reference.sample.images).not_to be_empty
      expect(reference.sample.images.first.file_derivatives.values_at(:mini, :thumb, :square, :wide).all?(&:present?)).to be true
      expect(reference.good_deal.starts_at.strftime("%d/%m/%Y")).to eq(dto_variant.good_deal.start_at)
      expect(reference.good_deal.discount).to eq(dto_variant.good_deal.discount)
      expect(reference.api_provider_variant.external_variant_id).to eq(dto_variant.provider[:external_variant_id])
      expect(reference.api_provider_variant.api_provider.name).to eq(dto_variant.provider[:name])
      characteristics = []
      characteristics << { name: 'color', value: reference.color.name }
      characteristics << { name: 'size', value: reference.size.name }
      characteristics.each do |charac|
        expect(dto_variant.characteristics.map(&:to_h)).to include(charac)
      end
    end
  end

  private
  def date_from_string(date_string:)
    return nil unless date_string

    date_array = date_string.split('/').map(&:to_i).reverse
    DateTime.new(date_array[0], date_array[1], date_array[2])
  end
end