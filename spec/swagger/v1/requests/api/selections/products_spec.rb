require 'swagger_helper'

RSpec.describe 'api/v1/selections/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/selections/{id}/products' do
    get('Returns products of an online selection.') do
      parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of a selection.'
      parameter name: :page, in: :query, type: :integer, example: 1, description: 'Number of desired page.'

      tags 'Selections'
      produces 'application/json'
      description 'Returns products of an online selection.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object,
          properties: {
            products: {
              type: :array,
              items: { '$ref': '#/components/schemas/Product' }
            },
            page: { type: :integer, example: 1 },
            totalPages: { type: :integer, example: 19 }
          }
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


  path '/api/v1/auth/admin/selections/{id}/products' do

    get('Returns all products of a selection.') do
      parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
      parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of a selection.'
      parameter name: :page, in: :query, type: :integer, example: 1, description: 'Number of desired page.'

      tags 'Selections'
      produces 'application/json'
      description 'Returns all products of a selection.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object,
          properties: {
            products: {
              type: :array,
              items: { '$ref': '#/components/schemas/Product' }
            },
            page: { type: :integer, example: 1 },
            totalPages: { type: :integer, example: 19 }
          }
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