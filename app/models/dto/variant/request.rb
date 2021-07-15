module Dto
  module Variant
    class Request
      attr_reader :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics, :image_urls
      
      def initialize(**args)
        @base_price = args[:base_price]
        @weight = args[:weight]
        @quantity = args[:quantity]
        @image_urls = []
        args[:@image_urls]&.each { |img_url| @image_urls << img_url }
        @is_default = args[:is_default]
        @good_deal = Dto::GoodDeal::Request.new(**args[:good_deal]) if args[:good_deal]
        @characteristics = []
        args[:characteristics]&.each { |c| @characteristics << Dto::Characteristic::Request.new(**c) }
      end
    end
  end
end