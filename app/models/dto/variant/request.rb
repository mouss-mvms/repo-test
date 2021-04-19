module Dto
  module Variant
    class Request
      attr_reader :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics
      
      def initialize(**args)
        @base_price = args[:base_price]
        @weight = args[:weight]
        @quantity = args[:quantity]
        @is_default = args[:is_default]
        @good_deal = args[:good_deal]
        @characteristics = args[:characteristics]
      end

      def self.create(**args)
        Dto::Variant::Request.new(
          base_price: args[:base_price],
          weight: args[:weight],
          quantity: args[:quantity],
          is_default: args[:is_default],
          good_deal: Dto::GoodDeal::Request.new(**args[:good_deal]&.symbolize_keys),
          characteristics: args[:characteristics]&.map { |c| Dto::Characteristic::Request.new(**c&.symbolize_keys) }
        )
      end

    end
  end
end