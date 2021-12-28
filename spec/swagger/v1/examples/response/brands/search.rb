module V1
  module Examples
    module Response
      module Brands
        class Search
          def self.to_h
            {
              type: :object,
              properties: {
                brands: {
                  type: :array,
                  items: V1::Examples::Response::BrandSummary.to_h
                },
                page: { type: :integer, description: 'Search page number.', example: 2 },
                totalPages: { type: :integer, description: 'Total number of page', example: 2 },
                totalCount: { type: :integer, description: 'Total Result count', example: 2 },
              }
            }
          end
        end
      end
    end
  end
end