module V1
  module Examples
    module Response
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
              page: { type: :string, description: 'Search page number.', example: "2" }
            },
          }
        end
      end
    end
  end
end
