module Dto
  module V1
    module Variant
      class Request
        attr_accessor :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics, :image_urls, :external_variant_id, :product_id, :files

        def initialize(**args)
          @id = args[:id]
          @product_id = args[:product_id]
          @base_price = args[:base_price]
          @weight = args[:weight]
          @quantity = args[:quantity] || 0
          @image_urls = []
          args[:image_urls]&.each { |img_url| @image_urls << img_url }
          @is_default = args[:is_default]
          @good_deal = Dto::V1::GoodDeal::Request.new(**args[:good_deal]) if args[:good_deal]
          @characteristics = []
          args[:characteristics]&.each { |c| @characteristics << Dto::V1::Characteristic::Request.new(**c) }
          @external_variant_id = args[:external_variant_id]
          @files = args[:files]
        end

        def to_h
          {
            id: @id,
            base_price: @base_price,
            weight: @weight,
            quantity: @quantity,
            image_urls: @image_urls,
            is_default: @is_default,
            good_deal: @good_deal.to_h,
            characteristics: @characteristics&.map { |characteristic| characteristic.to_h },
            product_id: @product_id,
            external_variant_id: @external_variant_id
          }
        end
      end
    end
  end
end