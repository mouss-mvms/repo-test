module Dto
  module V1
    module Brand
      module Search
        class Response
          attr_accessor :brands, :page, :total_pages, :total_count

          def initialize(**args)
            @brands = args[:brands].map { |brand| Dto::V1::BrandSummary::Response.create(brand.deep_symbolize_keys) }
            @page = args[:page]
            @total_pages = args[:total_pages]
            @total_count = args[:total_count]
          end

          def self.create(searchkick_brand_response)
            new(**searchkick_brand_response)
          end

          def to_h
            {
              brands: brands.map(&:to_h),
              page: page,
              totalPages: total_pages,
              totalCount: total_count
            }
          end
        end
      end
    end
  end
end