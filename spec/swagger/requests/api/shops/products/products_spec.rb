require 'swagger_helper'

RSpec.describe 'api/shops/products', type: :request do

  path '/api/shops/{shop_id}/products' do
    # You'll want to customize the parameter types...
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

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
