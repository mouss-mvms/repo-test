require 'swagger_helper'

RSpec.describe 'api/v1/citizens/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/auth/citizens/self/products/{product_id}/images/{id}' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of an image.'
    parameter name: :product_id, in: :path, type: :integer, description: 'Unique identifier of a product.'

    delete("Delete image of citizen's product") do
      tags 'Products'
      produces 'application/json'
      description "Delete image of citizen's product with status submitted."
      security [{ authorization: [] }]

      response(204, "Image deleted") do
        run_test!
      end

      response(400, "Bad Request") do
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