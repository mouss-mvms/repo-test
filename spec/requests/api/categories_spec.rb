require 'swagger_helper'

RSpec.describe '/categories', swagger_doc: 'v1/swagger.yaml', type: :request do
  path '/categories' do
    get('') do
      tags 'Categories'
      produces 'application/json'
      description 'Retrieve all categories.'
      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            categories: {
              type: :array,
              items: {
                '$ref': '#/components/schemas/Category'
              }
            }
          }
        run_test!
      end
    end
  end
end
