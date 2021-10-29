require "spec_helper"

RSpec.describe "api/v1/products/variants", swagger_doc: "v1/swagger.json", type: :request do
<<<<<<< HEAD
  path '/api/v1/products/{id}/variants' do
    post('Create a variant for a product.') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a variant for a product.'
      security [{ authorization: [] }]
      parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the product.'

      parameter name: :variant, in: :body, schema: {
        type: :object,
        properties: {
          basePrice: { type: :number, example: 44.99, description: "Price of product's variant" },
          weight: { type: :number, example: 0.56, description: "Weight of product's variant (in Kg)" },
          quantity: { type: :integer, example: 9, description: "Stock of product's variant" },
          isDefault: { type: :boolean, example: true, description: "Tell if this variant is the product's default variant" },
          goodDeal: {
            type: :object,
            properties: {
              startAt: { type: :string, example: "20/07/2021", description: "Date of start of good deal" },
              endAt: { type: :string, example: "27/07/2021", description: "Date of end of good deal" },
              discount: { type: :integer, example: 45, description: "Amount of discount (in %)" }
            },
            required: %w[startAt endAt discount]
          },
          characteristics: {
            type: :array,
            items: {
              type: :object,
              properties: {
                name: { type: :string, example: 'color', description: 'Name of characteristic' },
                value: { type: :string, example: 'Bleu', description: 'Value of characteristic' }
              },
              required: %w[name value]
            }
          },
          externalVariantId: { type: :string, example: '67ty7', description: 'Id of variant saved by the provider' },
        },
        required: %w[basePrice weight quantity isDefault externalVariantId]
      }

      response(201, 'Succesfull') do
        schema type: :object, '$ref': '#/components/schemas/Variant'
=======
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
>>>>>>> dev
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

<<<<<<< HEAD
      response(404, 'Product not found') do
=======
      response(401, 'Unauthorized') do
        schema Examples::Errors::Unauthorized.new.error
        run_test!
      end

      response(403, 'Forbidden') do
        schema Examples::Errors::Forbidden.new.error
        run_test!
      end

      response(404, 'Not found') do
>>>>>>> dev
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> dev
