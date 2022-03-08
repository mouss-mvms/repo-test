require 'swagger_helper'

RSpec.describe 'api/v1/shops/images', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/auth/shops/self/images/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the image'
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    delete('Delete an image from a shop') do
      tags 'Images'
      produces 'application/json'
      security [{ authorization: [] }]

      response(204, 'Successful') do
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

      response(404, 'Image not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
