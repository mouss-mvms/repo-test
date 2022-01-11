module V1
  module Examples
    module Response
      module Shops
        class Search
          def self.to_h
            {
              type: :object,
              properties: {
                shops: {
                  type: :array,
                  items: V1::Examples::Response::ShopSummary.to_h
                },
                filters: ::V1::Examples::Response::Searches::Filter.to_h,
                page: { type: :integer, description: 'Search page number.', example: 1 },
                totalPages: { type: :integer, description: 'Total search page number.', example: 15 },
                totalCount: { type: :integer, description: 'Total search hit number.', example: 302 }
              },
            }
          end
        end
      end
    end
  end
end
