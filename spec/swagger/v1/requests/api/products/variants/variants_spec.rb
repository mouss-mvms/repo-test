require "spec_helper"

RSpec.describe "api/v1/products/variants", swagger_doc: "v1/swagger.json", type: :request do
  path "/api/v1/products/{product_id}/variants/{id}" do
    parameter name: 'product_id', in: :path, type: :integer, required: true, description: "Id of the product requested"
    parameter name: 'id', in: :path, type: :integer, required: true, description: "Id of the variant to destroy"

    delete('Delete a variant for a product (offline)') do
      tags 'Variants'
      consumes 'application/json'
      produces 'application/json'
      description 'Delete a variant for a product (offline)'
      security [{ authorization: [] }]

      response(204, 'successful') do
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

  path '/api/v1/auth/products/{product_id}/variants/{id}' do
    parameter name: 'product_id', in: :path, type: :integer, required: true, description: "Id of the product requested"
    parameter name: 'id', in: :path, type: :integer, required: true, description: "Id of the variant to destroy"
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    delete('Delete a variant for a product') do
      tags 'Variants'
      consumes 'application/json'
      produces 'application/json'
      description 'Delete a variant for a product'
      security [{ authorization: [] }]

      response(204, 'successful') do
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
