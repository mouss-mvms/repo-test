module Dto
  module Variant
    class Response
      attr_reader :id, :base_price, :weight, :quantity, :is_default, :good_deal, :characteristics

      def initialize(**args)
        @id = args[:id]
        @base_price = args[:base_price]
        @weight = args[:weight]
        @quantity = args[:quantity]
        @is_default = args[:is_default]
        @good_deal = args[:good_deal]
        @characteristics = args[:characteristics] || []
      end
    
      def self.create(reference)
        variant = Dto::Variant::Response.new(
          id: reference.id, 
          weight: reference.weight, 
          quantity: reference.quantity, 
          base_price: reference.base_price, 
          is_default: reference.sample.default,
          good_deal: Dto::GoodDeal::Response.create(reference&.good_deal)
        )
        variant.send(:create_characteristics, reference)
        variant
      end    

      def to_h
        {
          id: @id,
          basePrice: @base_price,
          weight: @weight,
          quantity: @quantity,
          isDefault: @is_default,
          goodDeal: @good_deal&.to_h,
          characteristics: @characteristics&.map { |characteristic| characteristic.to_h }
        }
      end
    
      private
    
      def create_characteristics(reference)
        self.characteristics << Dto::Characteristic::Response.create(name: reference.color.name, type: 'color') if reference.color
        self.characteristics << Dto::Characteristic::Response.create(name: reference.size.name, type: 'size') if reference.size
      end
    end
  end
end