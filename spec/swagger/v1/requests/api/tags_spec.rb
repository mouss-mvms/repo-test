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

  path '/api/v1/tags' do
    get('Get list of tags') do
      parameter name: :page, in: :query, type: :integer, example: 1, description: "Number of the desired page.", required: true
      tags 'Tags'
      produces 'application/json'
      description 'Get the list of tags'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Tag'}
        run_test!
      end

    end
  end

  path '/api/v1/tags/{id}' do
    parameter name: :id, in: :path, type: :integer, example: 1, description: "Unique identifier of a tag."
    get('Retrieve a tag') do
      tags 'Tags'
      produces 'application/json'
      description 'Retrieve a tag by id'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema ::V1::Examples::Response::Tag.to_h
        run_test!
      end

      response(404, 'Tag not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

  end

  path '/api/v1/tags/{id}/products' do
    parameter name: :id, in: :path, type: :integer, example: 1, description: "Unique identifier of a tag"

    get('Get the products of a tag') do
      parameter name: :page, in: :query, type: :integer, example: 1, description: "Number of the desired page.", required: true

      tags 'Tags'
      produces 'application/json'
      description 'Get the products of a tag by id of tag'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Product'}
        run_test!
      end

      response(404, 'Tag not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
