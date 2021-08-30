require 'swagger_helper'

RSpec.describe 'api/v1/shops/deliveries', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/{id}/deliveries' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the shop.'

    get('List of deliveries by shop') do
      tags 'Deliveries'
      produces 'application/json'
      description 'List of deliveries available for a shop'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Delivery'}
        run_test!
      end
    end
  end
end
