module Dto
  module Product
    class Request
      attr_reader :name, :slug, :category_id, :brand, :status, :seller_advice, :is_service, :description, :variants, :image_urls, :citizen_advice

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
        args[:variants]&.each { |v| @variants << Dto::Variant::Request.new(v)}
        @citizen_advice = args[:citizen_advice]
        @category_id = args[:category_id]
      end
    end
  end
end