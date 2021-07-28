require 'swagger_helper'

RSpec.describe 'api/shops/schedules', type: :request do
  path '/api/shops/{id}/schedules' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    get("get shop's schedules") do
      tags 'Schedules'
      produces 'application/json'
      description 'Retrieve schedules from the given shop.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :array, items: { '$ref': '#/components/schemas/Schedule' }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object, oneOf: [{ '$ref': '#/components/schemas/NotFound' }]
        run_test!
      end
    end
  end
end
