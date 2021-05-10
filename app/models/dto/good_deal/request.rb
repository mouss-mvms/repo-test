module Dto
  module GoodDeal
    class Request
      attr_reader :start_at, :end_at, :discount
      
      def initialize(**args)
        @start_at = args[:start_at]
        @end_at = args[:end_at]
        @discount = args[:discount]
      end

    end
  end
end