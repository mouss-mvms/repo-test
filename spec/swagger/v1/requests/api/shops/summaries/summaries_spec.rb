require 'swagger_helper'

RSpec.describe 'api/v1/shops/summaries', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/summaries/search' do
    post("Search shops") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Search list of shops'
      security [{ authorization: [] }]

      parameter name: :shops, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "bordeaux", description: 'Territory or city slug.' },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          category: { type: :string, example: "alimentation", description: 'Category slug' },
          services: { type: :array, items:
            {
              type: 'string',
              example: "livraison-par-la-poste",
              description: 'Delivery service slug'
            }
          },
          page: { type: :integer, example: 1, description: 'Search page number.' },
          perPage: { type: :integer, example: 12, description: 'Number of results per page.', minimum: 1, maximum: 16 },
          perimeter: {
            type: :string,
            enum: [
              "department",
              "country"
            ]
          },
          sortBy: {
            type: :string,
            enum: ["name-asc", "name-desc", "random", "distance", "highest-score", "best-sells"]
          },
          excludeLocation: { type: :boolean, example: false, default: false, description: 'Only with a search with location params. Exclude the city of the search when perimeter params is department. Exclude city department from search when perimeter params is country.' },
          geolocOptions: {
            type: :object,
            properties: {
              lat: { type: :number, example: "-0.5862431", description: "Shop address latitude." },
              long: { type: :number, example: "44.8399608", description: "Shop address longitude." },
              radius: { type: :integer, example: 50000, description: "Research radius in meters.", minimum: 1 },
            },
            required: %w[lat long]
          }
        }
      }

      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/ShopSearch'
        run_test!
      end

      response(400, 'Bad Request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(404, 'Not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end