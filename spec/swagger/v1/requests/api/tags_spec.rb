require 'swagger_helper'

RSpec.describe 'api/v1/tags', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/tags' do
    get('Get list of tags') do
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

  path '/api/v1/tags/:id' do
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

  path '/api/v1/tags/:id/products' do
    get('Get the products of a tag') do
      tags 'Tags'
      produces 'application/json'
      description 'Get the products of a tag by id of tag'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Products'}
        run_test!
      end

      response(404, 'Tag not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
