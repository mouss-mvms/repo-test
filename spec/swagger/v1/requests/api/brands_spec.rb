require 'swagger_helper'

RSpec.describe 'api/v1/brands', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/auth/brands' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    post('Create a brand.') do
      tags 'Brands'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a brand.'
      security [{ authorization: [] }]

      parameter name: :brand, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Rebok", description: 'Name of brand.' },
        },
        required: %w[name]
      }

      response(200, 'successful') do
        schema ::V1::Examples::Response::Brand.to_h
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
    end
  end
end