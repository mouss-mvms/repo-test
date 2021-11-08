module V1
  module Examples
    module Response
      module Products
        class Search
          def self.to_h
            {
              type: :object,
              properties: {
                products: {
                  type: :array,
                  items: V1::Examples::Response::ProductSummary.to_h
                },
                filters: ::V1::Examples::Response::Searches::Filter.to_h,
                page: { type: :integer, description: 'Search page number.', example: 2 },
                totalPages: { type: :integer, description: 'Total search page number.', example: 15 }
              },
            }
          end
        end
      end
    end
  end
end
