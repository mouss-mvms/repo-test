require 'swagger_helper'

RSpec.describe 'api/shops', type: :request do
  path '/api/shops/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

      get("shop informations") do
        tags 'Shops'
        produces 'application/json'
        description 'Retrieve shop informations'
        security [{authorization: []}]

        response(200, 'Successful') do
          schema type: :object,
                 properties: {
                   products: {
                     type: :array,
                     items: {
                       '$ref': '#/components/schemas/Shop'
                     }
                   }
                 }
          run_test!
        end

        response(404, 'Not found') do
          schema type: :object,
                 properties: {
                   error: {'$ref': '#/components/schemas/Error'}
                 }
          run_test!
        end
    end
  end
end
