module Dto
  module Product
    class Request
      attr_reader :name, :slug, :category, :brand, :status, :seller_advice, :is_service, :description, :variants

      def initialize(**args)
        @name = args[:name]
        @slug = args[:slug]
        @category = args[:category]
        @brand = args[:brand]
        @status = args[:status]
        @is_service = args[:is_service]
        @seller_advice = args[:seller_advice]
        @description = args[:description]
        @variants = args[:variants] || []
      end  

      def self.create(**args)
        Dto::Product::Request.new( 
          name: args[:name],
          slug: args[:slug],
          category: args[:category],
          brand: args[:brand],
          status: args[:status],
          is_service: args[:is_service],
          seller_advice: args[:seller_advice],
          description: args[:description],
          variants: args[:variants]&.map { |v| Dto::Variant::Request.create(**v&.symbolize_keys) }
        )
      end

      def self.build(dto_product:, dto_category:, shop_id:)
        product = ::Product.create(
          name: dto_product.name,
          shop_id: shop_id,
          category_id: dto_category.id,
          brand_id: ::Brand.where(name: dto_product.brand).first_or_create.id,
          is_a_service: dto_product.is_service,
          status: dto_product.status || 'offline',
          pro_advice: dto_product.seller_advice,
          fields_attributes: [
            { lang: "fr", field: "description", content: dto_product.description },
            { lang: "en", field: "description", content: "" }
          ]
        )
    
        dto_product.variants.each do |dto_variant|
          sample = ::Sample.create(name: dto_product.name, default: dto_variant.is_default, product_id: product.id)
    
          dto_good_deal = dto_variant.good_deal
          good_deal = nil

          if dto_good_deal
            good_deal = ::GoodDeal.create(
              starts_at: dto_good_deal.start_at,
              ends_at: dto_good_deal.end_at,
              discount: dto_good_deal.discount,
              kind: "percentage"
            )
          end

          dto_variant.characteristics.each do |dto_characteristic|    
            ::Reference.create(
              weight: dto_variant.weight,
              quantity: dto_variant.quantity,
              base_price: dto_variant.base_price,
              product_id: product.id,
              sample_id: sample.id,
              shop_id: shop_id,
              good_deal_id: good_deal&.id,
              color_id: dto_characteristic.type == "color" ? ::Color.where(name: dto_characteristic.name).first_or_create.id : nil,
              size_id: dto_characteristic.type == "size" ? ::Size.where(name: dto_characteristic.name).first_or_create.id : nil
            )
          end
        end
    
        return product
      end
    end
  end
end