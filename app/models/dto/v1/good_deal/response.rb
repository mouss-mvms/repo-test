module Dto
  module V1
    module GoodDeal
      class Response
        attr_reader :start_at, :end_at, :discount, :discounted_price

        def initialize(**args)
          @start_at = args[:start_at]
          @end_at = args[:end_at]
          @discount = args[:discount]
          @discounted_price = args[:discounted_price]
        end

        def self.create(good_deal)
          return nil unless good_deal
          Dto::V1::GoodDeal::Response.new(
            start_at: good_deal.starts_at.strftime('%d/%m/%Y'),
            end_at: good_deal.ends_at.strftime('%d/%m/%Y'),
            discount: good_deal.discount
          )
        end

        def self.from_reference(reference)
          return nil unless reference.good_deal
          Dto::V1::GoodDeal::Response.new(
            start_at: reference.good_deal.starts_at.strftime('%d/%m/%Y'),
            end_at: reference.good_deal.ends_at.strftime('%d/%m/%Y'),
            discount: reference.good_deal.discount,
            discounted_price: reference.base_price - (reference.base_price*(reference.good_deal.discount/100))
          )
        end

        def to_h
          {
            startAt: @start_at,
            endAt: @end_at,
            discount: @discount,
            discountedPrice: @discounted_price
          }
        end
      end
    end
  end
end