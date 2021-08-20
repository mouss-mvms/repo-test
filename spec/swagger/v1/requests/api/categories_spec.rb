require 'swagger_helper'

RSpec.describe 'api/v1/categories', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/categories' do

    get('list categories') do
      tags 'Categories'
      produces 'application/json'
      description 'Return the list of categories.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Category'}
        run_test!
      end
    end
  end
end
