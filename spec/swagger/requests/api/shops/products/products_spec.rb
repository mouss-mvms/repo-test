require 'swagger_helper'

RSpec.describe 'api/shops/products', type: :request do

  path '/api/shops/{shop_id}/products' do
    # You'll want to customize the parameter types...
    parameter name: :shop_id, in: :path, type: :string, description: 'Unique identifier of the desired shop.'
    parameter name: :categories_slugs, in: :query, type: :string, description: 'Categories slugs', example: "vin-et-spiritueux/aperitif-et-spiritueux/rhum"
    parameter name: :prices, in: :query, type: :string, description: 'Prices range', example: '4__19'
    parameter name: :services, in: :query,type: :string, example: "livraison-par-la-poste__click-collect", description: 'Service slugs concatened with double "_" if more than one. (livraison-par-la-poste, livraison-france-metropolitaine, livraison-de-proximite, click-collect, e-reservation, livraison-par-colissimo, livraison-express-par-stuart, livraison-par-le-commercant, retrait-drive)'
    parameter name: :sort_by, in: :query, schema: {
      type: :string,
      enum: [
        "price-asc",
        "price-desc",
        "newest"
      ]
    }
    parameter name: :page, in: :query, type: :string, description: 'Number of the researches page'

    get('list products') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve all products from the given shop.'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Product'}
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/Unauthorized'}]
        run_test!
      end
    end
  end

end
