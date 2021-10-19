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
                page: { type: :string, description: 'Search page number.', example: "2" }
              }
            }
          end
        end
      end
    end
  end
end