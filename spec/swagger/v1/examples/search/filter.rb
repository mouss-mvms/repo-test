module V1
  module Examples
    module Search
      class Filter
        def self.to_h
          {
            type: :object,
            properties: {
              basePrice: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Base price value", example: "23" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "12" }
                  },
                }
              },
              colors: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Color name", example: "red" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "23" }
                  },
                }
              },
              sizes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Size name", example: "M" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "23" }
                  },
                }
              },
              services: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Service slug", example: "livraison-la-poste" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "23" }
                  },
                }
              },
              categories: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Category name", example: "homme/vetements" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "23" }
                  },
                }
              },
              brands: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    key: { type: :string, description: "Brand name", example: "Nike" },
                    value: { type: :string, description: "Number of occurrences for this key", example: "23" }
                  },
                }
              }
            }
          }
        end
      end
    end
  end
end
