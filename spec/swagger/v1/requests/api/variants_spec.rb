require 'swagger_helper'

RSpec.describe 'api/v1/variants', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/auth/variants/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the variant of a product.'
    put('Update a variant') do
      tags 'Variants'
      consumes 'application/json'
      produces 'application/json'
      description 'Return the variant updated'
      security [{ authorization: [] }]

      parameter name: :variant, in: :body, schema: {
        type: :object,
        properties: {
          basePrice: { type: :number, example: 44.99, description: "Price of product's variant" },
          weight: { type: :number, example: 0.56, description: "Weight of product's variant (in Kg)" },
          quantity: { type: :integer, example: 9, description: "Stock of product's variant" },
          isDefault: { type: :boolean, example: true, description: "Tell if this variant is the product's default variant" },
          imageUrls: {
            type: 'array',
            items: {
              type: 'string'
            },
            example: [
              'https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr',
              'https://leserigraphe.com/wp-content/uploads/2019/10/Walker-Texas-Ranger.jpg'
            ],
            default: [],
            description: 'List of product images urls'
          },
          goodDeal: {
            type: :object,
            properties: {
              startAt: { type: :string, example: "20/07/2021", description: "Date of start of good deal" },
              endAt: { type: :string, example: "27/07/2021", description: "Date of end of good deal" },
              discount: { type: :integer, example: 45, description: "Amount of discount (in %)" }
            },
            required: %w[startAt, endAt, discount]
          },
          characteristics: {
            type: :array,
            items: {
              type: :object,
              properties: {
                name: { type: :string, example: 'color', description: 'Name of characteristic' },
                value: { type: :string, example: 'Bleu', description: 'Value of characteristic' }
              },
              required: %w[name, value]
            }
          }
        },
        required: %w[basePrice, weight, quantity, isDefault]
      }

      response(200, 'Successful') do
        schema V1::Examples::Response::Variant.to_h
        run_test!
      end

      response(400, 'Bad Request') do
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

      response(404, 'Not Found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
