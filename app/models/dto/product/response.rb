module Dto
  module Product
    class Response
      attr_reader :id, :name, :slug, :category, :brand, :status, :seller_advice, :is_service, :description, :variants

      def initialize(**args)
        @id = args[:id]
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

      def self.create(product)
        Dto::Product::Response.new( 
          id: product.id, 
          name: product.name, 
          slug: product.slug, 
          brand: product&.brand&.name, 
          status: product.status, 
          is_service: product.is_a_service,
          seller_advice: product.pro_advice,
          category: Dto::Category::Response.create(product),
          variants: product.references&.map { |reference| Dto::Variant::Response.create(reference) }
        )
      end

      def to_h
        { product: {
            id: @id,
            name: @name,
            slug: @slug,
            description: @description,
            category: @category.to_h,
            brand: @brand,
            status: @status,
            sellerAdvice: @seller_advice,
            isService: @is_service,
            variants: @variants&.map { |variant| variant.to_h }
          }
        }
      end
    end
  end
end