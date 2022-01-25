module Dto
  module V1
    module Variant
      class Response
        attr_reader :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics, :image_urls, :provider

        def initialize(**args)
          @id = args[:id]
          @base_price = args[:base_price]
          @weight = args[:weight]
          @quantity = args[:quantity]
          @image_urls = args[:image_urls]
          @is_default = args[:is_default]
          @good_deal = args[:good_deal]
          @characteristics = args[:characteristics] || []
          @provider = args[:provider]
        end

        def self.create(reference)
          good_deal = reference.good_deal&.active ? Dto::V1::GoodDeal::Response.from_reference(reference) : nil
          variant = Dto::V1::Variant::Response.new(
            id: reference.id,
            weight: reference.weight,
            quantity: reference.quantity,
            image_urls: reference.sample.images.map(&:file_url),
            base_price: reference.base_price,
            is_default: reference.sample.default,
            good_deal: good_deal,
            provider: { name: reference.api_provider_variant&.api_provider&.name,
                        externalVariantId: reference.api_provider_variant&.external_variant_id }
          )
          variant.send(:create_characteristics, reference)
          variant
        end

        def to_h
          {
            id: @id,
            basePrice: @base_price,
            weight: @weight,
            quantity: @quantity,
            imageUrls: @image_urls,
            isDefault: @is_default,
            goodDeal: @good_deal&.to_h,
            characteristics: @characteristics&.map { |characteristic| characteristic.to_h },
            provider: @provider
          }
        end

        private

        def create_characteristics(reference)
          self.characteristics << Dto::V1::Characteristic::Response.new(name: 'color', value: reference.color.name) if reference.color
          self.characteristics << Dto::V1::Characteristic::Response.new(name: 'size', value: reference.size.name) if reference.size
        end
      end
    end
  end
end