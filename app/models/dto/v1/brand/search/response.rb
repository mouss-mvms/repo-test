module Dto
  module V1
    module Brand
      module Search
        class Response
          attr_accessor :brands, :page

          def initialize(**args)
            @brands = args[:brands].map { |brand| Dto::V1::BrandSummary::Response.create(brand.deep_symbolize_keys) }
            @page = args[:page]
          end

          def self.create(searchkick_brand_response)
            new(**searchkick_brand_response)
          end

          def to_h
            {
              brands: brands.map(&:to_h),
              page: page,
            }
          end
        end
      end
    end
  end
end