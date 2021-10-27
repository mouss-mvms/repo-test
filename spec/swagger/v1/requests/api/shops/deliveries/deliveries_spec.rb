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

  path '/api/v1/auth/shops/{id}/deliveries' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the shop.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user.', required: true

    put('Update delivery services for a shop') do
      tags 'Deliveries'
      consumes 'application/json'
      produces 'application/json'
      description 'Update delivery services for a shop'
      security [{authorization: []}]

      parameter name: :deliveries, in: :body, schema: {
        type: :object,
        properties: {
          serviceSlugs: {
            type: :array,
            items: {
              type: :string,
              description: "List of delivery service slugs.",
              example: ["click-collect", "livraison-par-le-commercant"]
            }
          },
          selfDeliveryPrice: {
            type: :number,
            example: 1.55,
            description: "Price of shop delivery."
          },
          freeDeliveryPrice: {
            type: :number,
            example: 45,
            description: "Minimal purchase amount for free shipping."
          }
        }

      }

      response(200, 'Successful') do
        schema type: :array, items: {'$ref': '#/components/schemas/Delivery'}
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
