module Dto
  module GoodDeal
    class Response
      attr_reader :start_at, :end_at, :discount

      def initialize(**args)
        @start_at = args[:start_at]
        @end_at = args[:end_at]
        @discount = args[:discount]
      end
    
      def self.create(good_deal)
        return nil unless good_deal
        Dto::GoodDeal::Response.new(
          start_at: good_deal.starts_at.strftime('%d/%m/%Y'),
          end_at: good_deal.ends_at.strftime('%d/%m/%Y'),
          discount: good_deal.discount
        )
      end

      def to_h
        {
          startAt: @start_at,
          endAt: @end_at,
          discount: @discount
        }
      end
    end
  end
end