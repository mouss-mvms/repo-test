require "spec_helper"

RSpec.describe "api/v1/products/summaries", swagger_doc: "v1/swagger.json", type: :request do
  path '/api/v1/products/summaries/search' do
    post('Return product-summaries list with filters') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return product-summaries list with filters'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "bordeaux", description: 'Territory or city slug.' },
          perimeter: {
            type: :string,
            enum: ["none", "city", "department", "country"]
          },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          category: { type: :string, example: "homme", description: 'Category slug' },
          prices: { type: :string, example: "1__100", description: 'Prices range' },
          sharedProducts: { type: :boolean, description: "Only shared products", example: false },
          services: {
            type: :array,
            items: {
              type: :string
            },
            example: ["livraison-par-la-poste", "livraison-france-metropolitaine"], description: 'Service slugs.' },
          sortBy: {
            type: :string,
            enum: ["highest-score", "price-asc", "price-desc", "newest", "position", "name-asc", "name-desc", "random"]
          },

          page: { type: :integer, example: 1, description: 'Search page number.' },
        }
      }
      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/ProductSearch'
        run_test!
      end
    end
  end

end
