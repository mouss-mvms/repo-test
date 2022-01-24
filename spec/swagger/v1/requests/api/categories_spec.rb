require 'swagger_helper'

RSpec.describe 'api/v1/categories', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/categories/roots' do
    parameter name: :children, in: :query, type: :boolean, description: 'Should return category children.'
    parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'

    get('list parents categories') do
      tags 'Categories'
      produces 'application/json'
      description 'Return the list of parents categories.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema ::V1::Examples::Response::Categories.to_h
        run_test!
      end

      response(404, 'Not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/categories/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the category.', required: true
    parameter name: :children, in: :query, type: :boolean, description: 'Should return category children.'
    parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'

    get('Show a category with it children') do
      tags 'Categories'
      produces 'application/json'
      description 'Return a category with it children.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema ::V1::Examples::Response::Category.to_h
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(404, 'Not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
