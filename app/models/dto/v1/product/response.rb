module Dto
  module V1
    module Product
      class Response
        attr_reader :id, :name, :slug, :category, :brand, :status, :seller_advice, :is_service, :description, :variants, :citizen_advice, :origin, :allergens, :composition, :provider, :shop_id, :shop_name, :citizen
        attr_reader :created_at, :updated_at, :type_citizen_refuse, :text_citizen_refuse

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
          @description = args[:description]
          @variants = []
          args[:variants]&.each do |variant|
            @variants << variant
          end
          @citizen_advice = args[:citizen_advice]
          @provider = args[:provider]
          @citizen = args[:citizen]
          @created_at = args[:created_at]
          @updated_at = args[:updated_at]
          @type_citizen_refuse = args[:type_citizen_refuse]
          @text_citizen_refuse = args[:text_citizen_refuse]
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
            category: Dto::V1::Category::Response.create(product.category),
            variants: product.references&.map { |reference| Dto::V1::Variant::Response.create(reference) },
            citizen_advice: product.advice&.content,
            provider: { name: product.api_provider_product&.api_provider&.name, externalProductId: product.api_provider_product&.external_product_id },
            citizen: citizen,
            created_at: product.created_at,
            updated_at: product.updated_at,
            type_citizen_refuse: product.type_citizen_refuse,
            text_citizen_refuse: product.text_citizen_refuse
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
            shopId: @shop_id,
            shopName: @shop_name,
            sellerAdvice: @seller_advice,
            isService: @is_service,
            variants: @variants&.map { |variant| variant.to_h },
            citizenAdvice: @citizen_advice,
            provider: @provider,
            citizen: @citizen&.to_h,
            createdAt: @created_at,
            updatedAt: @updated_at,
            typeCitizenRefuse: @type_citizen_refuse,
            textCitizenRefuse: @text_citizen_refuse,
          }
        end
      end
    end
  end
end