module Dto
  module V1
    module GoodDeal
      class Request
        attr_reader :start_at, :end_at, :discount

        def initialize(**args)
          @start_at = args[:start_at] || nil
          @end_at = args[:end_at] || nil
          @discount = args[:discount] || 0.0
        end

        def to_h
          {
            start_at: start_at,
            end_at: end_at,
            discount: discount
          }
        end
      end
    end
  end
end