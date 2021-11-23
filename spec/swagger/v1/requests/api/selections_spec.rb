require 'swagger_helper'

RSpec.describe 'api/v1/selections', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/auth/selections' do
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    post('create a selection') do
      tags 'Selections'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a selection.'
      security [{ authorization: [] }]

      parameter name: :selection, in: :body, schema: {
        type: :object,
        description: 'Route to create a selection',
        properties: {
          name: { type: :string, example: "voiture", description: 'Selection name.' },
          description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
          tagIds: {
            type: :array,
            items: { type: :integer, example: 12, description: 'Tag id.' }
          },
          startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
          endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
          homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
          event: { type: :boolean, example: false, description: 'Selection is an event.' },
          state: {
            type: :string,
            enum: ["disabled", "active"]
          },
          imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" }
        },
        required: %w[name description imageUrl]
      }

      response(201, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/selections/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the selection.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    patch('update a selection') do
      tags 'Selections'
      produces 'application/json'
      consumes 'application/json'
      description 'Update a selection.'
      security [{ authorization: [] }]

      parameter name: :selection, in: :body, schema: {
        type: :object,
        description: 'Route to update a selection',
        properties: {
          name: { type: :string, example: "voiture", description: 'Selection name.' },
          description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
          tagIds: {
            type: :array,
            items: { type: :integer, example: 12, description: 'Tag id.' }
          },
          startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
          endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
          homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
          event: { type: :boolean, example: false, description: 'Selection is an event.' },
          state: {
            type: :string,
            enum: ["disabled", "active"]
          },
          imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" }
        }
      }

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('delete a selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Delete a selection.'
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
