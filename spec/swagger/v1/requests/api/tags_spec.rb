require 'rails_helper'

RSpec.describe 'api/v1/tags', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/auth/admin/tags' do
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    post('Create a tag.') do
      tags 'Tags'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a tag.'
      security [{ authorization: [] }]

      parameter name: :tag, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Noël', description: 'Name of the Tag.' },
          status: { type: :string, example: 'active', enum: ['active', 'not_active'], description: 'Status of the Tag.' },
          featured: { type: :boolean, example: true },
          imageUrl: { type: :string, example: 'https://path/to/image.jpeg', description: 'Image url of the Tag.' }
        },
        required: %w[name status]
      }

      response(201, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Tag'
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
