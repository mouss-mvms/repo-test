module Dto
  module V1
    module Product
      module Search
        class Response
          attr_accessor :products, :filters, :page

          def initialize(**args)
            @products = args[:products].map { |product| Dto::V1::ProductSummary::Response.create(product.deep_symbolize_keys) }
            @filters = ::Dto::V1::Search::Filter::Response.create(args[:aggs])
            @page = args[:page]
          end

          def self.create(searchkick_product_response)
            self.new(**searchkick_product_response)
          end

          def to_h
            {
              products: @products.map(&:to_h),
              filters: @filters.to_h,
              page: @page,
            }
          end
        end
      end
    end
  end
end