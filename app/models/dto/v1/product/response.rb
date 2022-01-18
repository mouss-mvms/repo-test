module Dto
  module V1
    module Product
      class Response
        attr_reader :id, :name, :slug, :category, :brand, :status, :seller_advice, :is_service, :description, :variants, :image_urls, :citizen_advice, :origin, :allergens, :composition, :provider, :shop_id, :shop_name, :citizen

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @category = args[:category]
          @brand = args[:brand]
          @status = args[:status]
          @is_service = args[:is_service]
          @seller_advice = args[:seller_advice]
          @shop_id = args[:shop_id]
          @shop_name = args[:shop_name]
          @image_urls = args[:image_urls]
          @description = args[:description]
          @variants = []
          args[:variants]&.each do |variant|
            @variants << variant
          end
          @citizen_advice = args[:citizen_advice]
          @provider = args[:provider]
          @citizen = args[:citizen]
        end

        def self.create(product)
          citizen = product.citizens.any? ? Dto::V1::Citizen::Response.create(product.citizens.first) : nil
          Dto::V1::Product::Response.new(
            id: product.id,
            name: product.name,
            description: product.description,
            slug: product.slug,
            brand: product.brand&.name,
            status: product.status,
            is_service: product.is_a_service,
            seller_advice: product.pro_advice,
            shop_id: product.shop.id,
            shop_name: product.shop.name,
            image_urls: product.images.map(&:file_url),
            category: Dto::V1::Category::Response.create(product.category),
            variants: product.references&.map { |reference| Dto::V1::Variant::Response.create(reference) },
            citizen_advice: product.advice&.content,
            provider: { name: product.api_provider_product&.api_provider&.name, externalProductId: product.api_provider_product&.external_product_id },
            citizen: citizen
          )
        end

        def to_h
          {
            id: @id,
            name: @name,
            slug: @slug,
            description: @description,
            category: @category.to_h,
            brand: @brand,
            status: @status,
            imageUrls: @image_urls,
            shopId: @shop_id,
            shopName: @shop_name,
            sellerAdvice: @seller_advice,
            isService: @is_service,
            variants: @variants&.map { |variant| variant.to_h },
            citizenAdvice: @citizen_advice,
            provider: @provider,
            citizen: @citizen&.to_h,
          }
        end
      end
    end
  end
end