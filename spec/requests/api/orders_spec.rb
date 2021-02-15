require 'swagger_helper'

RSpec.describe '/orders', swagger_doc: 'swagger.yaml', type: :request do
  path '/shops/{shopId}/orders' do
    get('') do
      tags 'Orders'
      produces 'application/json'
      description 'Retrieve all orders from the given shop.'
      parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'

      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            orders: {
              type: :array,
              items: {
                '$ref': '#/components/schemas/Order'
              }
            }
          }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end

    post('') do
      tags 'Orders'
      consumes 'application/json'
      produces 'application/json'
      description 'Create an order in the given shop.'
      parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
      parameter name: :order, in: :body, schema: { '$ref'=> '#/components/schemas/NewOrder' }

      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            order: { '$ref': '#/components/schemas/Order' }
          }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
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

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
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
