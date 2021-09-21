require 'swagger_helper'

RSpec.describe 'api/v1/citizens/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/citizens/{id}/products' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the citizen.'

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
        schema type: :object, '$ref': '#/components/schemas/BadRequest'
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object, '$ref': '#/components/schemas/NotFound'
        run_test!
      end
    end

  end
end
