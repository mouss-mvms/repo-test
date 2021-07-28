require 'swagger_helper'

RSpec.describe 'api/citizens/products', type: :request do
  path '/api/citizens/{id}/products' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the citizen.'
    parameter name: :city, in: :query, type: :string, description: 'City or Territory slug', example: 'bordeaux'
    parameter name: :category, in: :query, type: :string, description: 'Category slug', example: "vin-et-spiritueux/aperitif-et-spiritueux/rhum"
    parameter name: :perimeter, in: :query, schema:{
      type: :string,
      enum: ["none", "around_me", "all"],
      description: 'Search perimeter'
    }
    parameter name: :price, in: :query, type: :string, description: 'Prices range', example: '4__19'
    parameter name: :services, in: :query,type: :string, example: "livraison-par-la-poste__click-collect", description: 'Service slugs concatened with double "_" if more than one. (livraison-par-la-poste, livraison-france-metropolitaine, livraison-de-proximite, click-collect, e-reservation, livraison-par-colissimo, livraison-express-par-stuart, livraison-par-le-commercant, retrait-drive)'
    parameter name: :sort_by, in: :query, schema: {
      type: :string,
      enum: [
        "price-asc",
        "price-desc",
        "newest"
      ]
    }

    get('retrieve products of a citizen') do
      tags 'Citizens'
      produces 'application/json'
      description 'Retrieve a product from a citizen.'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Product'}
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/NotFound'}]
        run_test!
      end
    end

  end
end
