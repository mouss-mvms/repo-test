require 'swagger_helper'

RSpec.describe 'api/v1/products/reviews', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/auth/products/{id}/reviews' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the products.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
    post('Create a review for a product') do
      tags 'Review'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a review for a product or create an answer for an existing review'
      security [{ authorization: [] }]

      parameter name: :review, in: :body, schema: {
        type: :object,
        description: 'To create a review, productId and mark are required, parentId is forbidden.
                      To create an answer, parentId is required but mark is forbidden',
        properties: {
          mark: { type: :integer, example: 3, description: 'Mark of review (0 to 5)' },
          content: { type: :string, example: 'La boutique est super', description: 'Content of review' },
          parentId: { type: :integer, example: 52, description: 'Parent id review if current review is an answer to another review' },
          required: [ 'content' ]
        }
      }

      response(201, 'successful') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/Review'}]
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object, oneOf: [{ '$ref': '#/components/schemas/Unauthorized' }]
        run_test!
      end

      response(403, 'Forbidden') do
        schema type: :object, oneOf: [{ '$ref': '#/components/schemas/Forbidden' }]
        run_test!
      end

      response(404, 'Product not found') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/NotFound'}]
        run_test!
      end
    end
  end

end