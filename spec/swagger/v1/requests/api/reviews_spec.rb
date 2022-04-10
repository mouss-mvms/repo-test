require 'swagger_helper'

RSpec.describe 'api/v1/reviews', swagger_doc: swagger_path(version: 1), type: :request do
  path '/api/v1/auth/reviews/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the review.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    put('Update a review') do
      tags 'Reviews'
      produces 'application/json'
      consumes 'application/json'
      description 'Update a review (content, mark or isWarned)'
      security [{ authorization: [] }]

      parameter name: :review, in: :body, schema: {
        type: :object,
        description: 'Route to update a review',
        properties: {
          mark: { type: :integer, example: 3, description: 'Mark of review (0 to 5)' },
          content: { type: :string, example: 'La boutique est super', description: 'Content of review' },
          isWarned: { type: :boolean, example: false, description: 'Attribute to report review' },
        }
      }

      response(200, 'successful') do
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

      response(404, 'Review not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('Delete a review') do
      tags 'Reviews'
      produces 'application/json'
      consumes 'application/json'
      description 'Delete a review'
      security [{ authorization: [] }]

      response(204, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Review'
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

      response(404, 'Review not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
