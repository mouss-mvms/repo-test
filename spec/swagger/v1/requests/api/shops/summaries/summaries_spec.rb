require 'swagger_helper'

RSpec.describe 'api/v1/shops/summaries', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/summaries/search' do
    post("List of shop summaries with filters") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'List of shop summaries with filters'
      security [{authorization: []}]

      parameter name: :shops, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "bordeaux", description: 'Territory or city slug.' },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          categories: { type: :string, example: "homme", description: 'Categories slugs concatened with double "_" if more than one.' },
          services: { type: :string, example: "livraison-par-la-poste__livraison-france-metropolitaine", description: 'Service slugs concatened with double "_" if more than one.' },
          page: { type: :string, example: '1', description: 'Search page number.' },
          more: { type: :boolean, description: 'Increase research perimeter scope' },
          name: {
            type: :string,
            enum: [
              "around_me",
              "all"
            ]
          },
          # geolocOptions: {
          #   type: :object,
          #   properties: {
          #     lat: { type: :number, example: "-1.678979", description: "Shop address latitude." },
          #     long: { type: :number, example: "4.672382", description: "Shop address longitude." },
          #     radius: { type: :integer, example: "1200", description: "Research radius in meters.", minimum: 50, maximum: 100000 },
          #   }
          # }
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