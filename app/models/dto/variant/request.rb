module Dto
  module Variant
    class Request
      attr_reader :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics
      
      def initialize(**args)
        @base_price = args[:base_price]
        @weight = args[:weight]
        @quantity = args[:quantity]
        @is_default = args[:is_default]
        @good_deal = Dto::GoodDeal::Request.new(**args[:good_deal] || {})
        @characteristics = []
        args[:characteristics]&.each { |c| @characteristics << Dto::Characteristic::Request.new(**c) }
      end
    end
  end
end