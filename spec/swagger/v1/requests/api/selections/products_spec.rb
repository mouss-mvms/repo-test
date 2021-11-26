require 'swagger_helper'

RSpec.describe 'api/v1/selections/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/selections/{id}/products' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of a selection.'
    get('Returns an online selection and all of its products.') do
      tags 'Selections'
      produces 'application/json'
      description 'Returns an online selection and all of its products.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                 selection: { '$ref': '#/components/schemas/Selection' },
                 products: {
                   type: :array,
                   items: {
                    '$ref': '#/components/schemas/Product'
                   }
                 }
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
end