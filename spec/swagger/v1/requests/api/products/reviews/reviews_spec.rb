require 'swagger_helper'

RSpec.describe 'api/v1/products/reviews', swagger_doc: swagger_path(version: 1), type: :request do

  path '/api/v1/auth/products/{id}/reviews' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the products.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
    post('Create a review for a product') do
      tags 'Reviews'
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
        },
        required: %w[content]
      }

      response(201, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Review'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(401, 'Unauthorized') do
        schema Examples::Errors::Unauthorized.new.error
        run_test!
      end

      response(403, 'Forbidden') do
        schema Examples::Errors::Forbidden.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}/reviews' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the products.', required: true
    get('Get reviews for a product.') do
      parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'

      tags 'Reviews'
      produces 'application/json'
      description 'Get reviews for a product.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :array, items: { '$ref': '#/components/schemas/Review' }
        run_test!
      end

      response(304, 'Not Modified') do
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(401, 'Unauthorized') do
        schema Examples::Errors::Unauthorized.new.error
        run_test!
      end

      response(403, 'Forbidden') do
        schema Examples::Errors::Forbidden.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
