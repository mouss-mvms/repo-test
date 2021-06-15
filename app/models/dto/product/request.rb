module Dto
  module Product
    class Request
      attr_reader :name, :slug, :category, :brand, :status, :seller_advice, :is_service, :description, :variants, :image_urls

      def initialize(**args)
        @name = args[:name]
        @slug = args[:slug]
        @category = args[:category]
        @brand = args[:brand]
        @status = args[:status]
        @image_urls = args[:image_urls] || []
        @is_service = args[:is_service]
        @seller_advice = args[:seller_advice]
        @description = args[:description]
        @variants = []
        args[:variants]&.each { |v| @variants << Dto::Variant::Request.new(**v)}
      end
    end
  end
end