module Dto
  module V1
    module Product
      class Request

        attr_accessor :id, :name, :slug, :category_id, :brand, :status, :seller_advice, :is_service, :description, :variants, :citizen_advice, :citizen_id, :shop_id, :origin, :composition, :allergens, :provider

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @brand = args[:brand]
          @status = args[:status]
          @is_service = args[:is_service]
          @seller_advice = args[:seller_advice]
          @description = args[:description]
          @variants = []
          args[:variants]&.each { |v| @variants << Dto::V1::Variant::Request.new(v)}
          @citizen_advice = args[:citizen_advice]
          @citizen_id = args[:citizen_id] || nil
          @category_id = args[:category_id]
          @shop_id = args[:shop_id]
          @origin = args[:origin]
          @allergens = args[:allergens]
          @composition = args[:composition]
          if args[:provider]
            @provider = {
              name: args[:provider][:name],
              external_product_id: args[:provider][:external_product_id]
            }
          end
        end

        def to_h
          {
            id: @id,
            name: @name,
            slug: @slug,
            shop_id: @shop_id,
            description: @description,
            category_id: @category_id,
            brand: @brand,
            status: @status,
            image_urls: @image_urls,
            image_ids: @image_ids,
            seller_advice: @seller_advice,
            is_service: @is_service,
            variants: @variants&.map { |variant| variant.to_h },
            citizen_advice: @citizen_advice,
            citizen_id: @citizen_id,
            origin: @origin,
            allergens: @allergens,
            composition: @composition,
            provider: @provider
          }
        end
      end
    end
  end
end