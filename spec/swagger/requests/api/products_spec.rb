require 'swagger_helper'

RSpec.describe 'api/categories', type: :request do
  path '/api/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'

    put('Update a product (offline)') do
      tags 'Products'
      produces 'application/json'
      description 'Return the product updated'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end
  end

  path '/api/auth/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'

    put('Update a product') do
      tags 'Products'
      produces 'application/json'
      description 'Return the product updated'
      security [{ authorization: [] }]

      parameter name: 'X-client-id', in: :header

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                 categories: {
                   type: :array,
                   items: {
                     '$ref': '#/components/schemas/Product'
                   }
                 }
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Unauthorized'}
               }
        run_test!
      end

      response(403, 'Forbidden') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/Forbidden'}
               }
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object,
               properties: {
                 error: {'$ref': '#/components/schemas/NotFound'}
               }
        run_test!
      end
    end
  end
end
