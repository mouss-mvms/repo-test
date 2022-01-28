module Dto
  module V1
    module Variant
      class Request
        attr_accessor :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics, :image_urls, :image_ids, :external_variant_id, :product_id, :files, :provider

        def initialize(**args)
          @id = args[:id]
          @product_id = args[:product_id]
          @base_price = args[:base_price]
          @weight = args[:weight]
          @quantity = args[:quantity]
          @image_urls = []
          args[:image_urls]&.each { |img_url| @image_urls << img_url }
          @image_ids = []
          args[:image_ids]&.each { |image_id| @image_ids << image_id}
          @is_default = args[:is_default]
          @good_deal = Dto::V1::GoodDeal::Request.new(**args[:good_deal]) if args[:good_deal]
          @characteristics = []
          args[:characteristics]&.each { |c| @characteristics << Dto::V1::Characteristic::Request.new(**c) }
          @files = []
          args[:files]&.each do |file|
            @files << file unless file.blank?
          end
          if args[:provider]
            @provider = {
              name: args[:provider][:name],
              external_variant_id: args[:provider][:external_variant_id]
            }
          end
        end

        def to_h
          {
            id: @id,
            base_price: @base_price,
            weight: @weight,
            quantity: @quantity,
            image_urls: @image_urls,
            image_ids: @image_ids,
            is_default: @is_default,
            good_deal: @good_deal.to_h,
            characteristics: @characteristics&.map { |characteristic| characteristic.to_h },
            product_id: @product_id,
            provider: @provider
          }
        end
      end
    end
  end
end