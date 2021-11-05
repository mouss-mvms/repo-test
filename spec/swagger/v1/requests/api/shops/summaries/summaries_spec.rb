require 'swagger_helper'

RSpec.describe 'api/v1/shops/summaries', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/summaries/search' do
    post("Search shops") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Search list of shops'
      security [{authorization: []}]

      parameter name: :shops, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "bordeaux", description: 'Territory or city slug.' },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          category: { type: :string, example: "homme", description: 'Category slug' },
          services: { type: :array, items: { type: 'string', example: "livraison-par-la-poste", description: 'Delivery service slug' } },
          page: { type: :string, example: '1', description: 'Search page number.' },
          perimeter: {
            type: :string,
            enum: [
              "department",
              "country"
            ]
          },
          geolocOptions: {
            type: :object,
            properties: {
              lat: { type: :number, example: "-1.678979", description: "Shop address latitude.", required: true },
              long: { type: :number, example: "4.672382", description: "Shop address longitude.", required: true },
              radius: { type: :integer, example: 1200, description: "Research radius in meters.", minimum: 1 },
            }
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