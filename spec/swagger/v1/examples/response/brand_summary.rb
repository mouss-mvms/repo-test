module V1
  module Examples
    module Response
      class BrandSummary
        def self.to_h
          {
            type: :object,
            properties: {
              _index: { type: :string, example: "brands_v1_20210315162727103" },
              _id: { type: :string, example: "21034" },
              _type: { type: :string, example: "_doc" },
              _score: { type: :number, example: 0.9976985 },
              id: { type: :integer, example: 1 },
              name: { type: :string, example: "Rebok" },
              products_count: { type: :integer, example: 61 }
            }
          }
        end
      end
    end
  end
end
