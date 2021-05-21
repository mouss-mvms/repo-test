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
    end
  end
end