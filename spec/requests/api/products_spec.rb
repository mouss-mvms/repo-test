require 'swagger_helper'

RSpec.describe '/products', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/shops/{shopId}/products' do
    parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
    get('') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve all products from the given shop.'
      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            products: {
              type: :array,
              items: {
                '$ref': '#/components/schemas/Product'
              }
            }
          }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('') do
      tags 'Products'
      produces 'application/json'
      description 'Create a product in the given shop.'
      parameter name: :product, in: :body, schema: { '$ref'=> '#/components/schemas/Product' }
      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            product: { '$ref': '#/components/schemas/Product' }
          }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
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

  path '/shops/{shopId}/products/{productId}' do
    parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
    parameter name: :productId, in: :path, type: :integer, description: 'Unique identifier of the desired product.'

    get('') do 
      tags 'Products'
      produces 'application/json'
      description 'Retrieve a single product from the given shop.'
      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            product: { '$ref': '#/components/schemas/Product' }
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
