require 'swagger_helper'

RSpec.describe '/orders', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/shops/{shopId}/orders' do
    post('') do
      tags 'Orders'
      produces 'application/json'
      description 'Create an order in the given shop.'
      parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
      parameter name: :product, in: :body, schema: { '$ref'=> '#/components/schemas/Order' }
      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            order: { '$ref': '#/components/schemas/Order' }
          }
        run_test!
      end
      response(422, 'Invalid request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end
  end

  path '/shops/{shopId}/orders/{orderId}' do
    parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
    parameter name: :orderId, in: :path, type: :integer, description: 'Unique identifier of the desired order.'
    delete('') do
      tags 'Orders'
      produces 'application/json'
      description 'Delete an order from the given shop.'
      response(200, 'Successful response') do
        run_test!
      end
      response(404, 'Not found') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end
  end
end
