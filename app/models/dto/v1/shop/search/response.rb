module Dto
  module V1
    module Shop
      module Search
        class Response
          attr_accessor :shops, :filters, :page

          def initialize(**args)
            @shops = args[:shops].map { |shop| Dto::V1::ShopSummary::Response.create(shop.deep_symbolize_keys) }
            @filters = ::Dto::V1::Search::Filter::Response.create(args[:aggs])
            @page = args[:page]
          end

          def self.create(searchkick_product_response)
            self.new(**searchkick_product_response)
          end

          def to_h
            {
              shops: @shops.map(&:to_h),
              filters: @filters.to_h,
              page: @page,
            }
          end
        end
      end
    end
  end
end