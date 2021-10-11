module Dto
  module V1
    module Product
      class Request
        attr_accessor :name, :slug, :category_id, :brand, :status, :seller_advice, :is_service, :description, :variants, :image_urls, :citizen_advice, :citizen_id, :shop_id, :origin, :composition, :allergens, :provider

        def initialize(**args)
          @name = args[:name]
          @slug = args[:slug]
          @brand = args[:brand]
          @status = args[:status]
          @image_urls = []
          args[:image_urls]&.each { |v| @image_urls << v}
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
          @provider = args[:provider]
        end

        def to_h
          {
            name: @name,
            slug: @slug,
            shop_id: @shop_id,
            description: @description,
            category_id: @category_id,
            brand: @brand,
            status: @status,
            image_urls: @image_urls,
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