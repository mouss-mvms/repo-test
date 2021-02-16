require 'swagger_helper'

RSpec.describe '/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/shops/{shopId}/products' do
    parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'

    get('') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve all products from the given shop.'

      response(201, 'Successful response') do
        schema type: :object,
          properties: {
            products: {
              type: :array,
              items: {
                '$ref': '#/components/schemas/Product'
              }
            }
          }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end

    post('') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a product in the given shop.'
      parameter name: :product, in: :body, schema: {
        type: 'object',
        properties: {
          name: {
            type: 'string',
            example: 'Chaise longue',
            description: 'Display name of a product.'
          },
          description: {
            type: 'string',
            example: 'Chaise longue pour jardin extérieur.',
            description: 'Description of a product.'
          },
          categoryId: {
            type: 'integer',
            example: 1,
            description: 'Unique identifier of a category.'
          },
          brand: {
            type: 'string',
            example: 'Lafuma',
            description: 'Brand of a product.'
          },
          status: {
            type: 'string',
            example: 'online',
            default: 'not_online',
            enum: ['not_online', 'online', 'draft_cityzen', 'submitted', 'refused'],
            description: 'Status of a product.'
          },
          sellerAdvice: {
            type: 'string',
            example: 'Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.',
            description: 'Seller advice of a product'
          },
          isService: {
            type: 'boolean',
            example: false,
            description: 'This product is a merchandise or a service.'
          },
          variants: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                basePrice: {
                  type: 'number',
                  format: 'double',
                  example: 20.50,
                  description: 'Base price of a variant.'
                },
                weight: {
                  type: 'number',
                  format: 'double',
                  nullable: true,
                  example: 20.50,
                  description: 'Weight in grams of a variant.'
                },
                quantity: {
                  type: 'integer',
                  example: 20,
                  description: 'Quantity in stock of a variant.'
                },
                isDefault: {
                  type: 'boolean',
                  default: false,
                  description: 'Default state of a variant.'
                },
                goodDeal: {
                  '$ref': '#/components/schemas/GoodDeal',
                  description: 'Good deal of a variant.'
                },
                characteristics: {
                  type: 'array',
                  items: {
                    '$ref': '#/components/schemas/Characteristic'
                  },
                  description: 'List of characteristics.'
                }
              },
              required: %w[basePrice quantity]
            }
          },
          description: 'List of variants.'
        },
        required: %w[name]
      }

      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            product: { '$ref': '#/components/schemas/Product' }
          }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end
  end

  path '/shops/{shopId}/products/{productId}' do
    parameter name: :shopId, in: :path, type: :integer, description: 'Unique identifier of the desired shop.'
    parameter name: :productId, in: :path, type: :integer, description: 'Unique identifier of the desired product.'

    get('') do 
      tags 'Products'
      produces 'application/json'
      description 'Retrieve a single product from the given shop.'

      response(200, 'Successful response') do
        schema type: :object,
          properties: {
            product: { '$ref': '#/components/schemas/Product' }
          }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
          properties: {
            error: { '$ref': '#/components/schemas/Error' }
          }
        run_test!
      end
    end
  end
end
