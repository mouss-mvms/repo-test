require 'swagger_helper'

RSpec.describe 'api/v1/shops/schedules', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/{id}/schedules' do
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
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

  end

  path '/api/v1/auth/shops/{id}/schedules' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user'

    put("Update shop's schedules") do
      tags 'Schedules'
      produces 'application/json'
      consumes 'application/json'
      description 'Update schedules from the given shop.'
      security [{ authorization: [] }]

      parameter name: 'schedules', in: :body, schema: {
        type: :array,
        items: {
          type: :object,
          properties: {
            id: { type: :integer, example: 3, description: 'Id of schedule that you want to update' },
            openMorning: { type: :string, example: '10:00', description: 'Open morning time' },
            openAfternoon: { type: :string, example: '13:00', description: 'Close morning time' },
            closeMorning: { type: :string, example: '14:00', description: 'Open afternoon time' },
            closeAfternoon: { type: :string, example: '20:00', description: 'Close afternoon time' }
          }
        }
      }

      response(200, 'Successful') do
        schema type: :array, items: { '$ref': '#/components/schemas/Schedule' }
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
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

      response(404, 'Not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
