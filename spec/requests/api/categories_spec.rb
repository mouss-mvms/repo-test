require 'swagger_helper'

RSpec.describe 'api/categories', type: :request do

  path '/api/categories' do

    get('list categories') do
      tags 'Categories'
      produces 'application/json'
      description 'Return the list of categories.'
      security [{ apikey: [] }]
      response(200, 'successful') do
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
