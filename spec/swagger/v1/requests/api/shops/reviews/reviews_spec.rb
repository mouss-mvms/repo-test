require 'swagger_helper'

RSpec.describe 'api/v1/shops/reviews', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/auth/shops/{id}/reviews' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the shop.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
    post('Create a review for a shop') do
      tags 'Reviews'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a review for a shop or create an answer for an existing review'
      security [{ authorization: [] }]

      parameter name: :review, in: :body, schema: {
        type: :object,
        description: 'To create a review, shopId and mark are required, parentId is forbidden.
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

  path '/api/v1/shops/{id}/reviews' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the shop.', required: true

    get('Get reviews for a shop.') do
      tags 'Reviews'
      produces 'application/json'
      consumes 'application/json'
      description 'Get reviews for a shop.'
      security [{ authorization: [] }]

      response(200, 'Succesfull') do
        schema type: :array, items: { '$ref': '#/components/schemas/Review' }
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
