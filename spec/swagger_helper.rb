# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.json' => {
      openapi: '3.0.1',
      info: {
        title: 'CATALOG API',
        version: '0.1.0',
        description: 'Ma Ville Mon Shopping Catalog API'
      },
      paths: {},
      servers: [
        {
          url: ENV['BASE_URL'].to_s
        }
      ],
      components: {
        securitySchemes: {
          authorization: {
            type: :apiKey,
            name: 'authorization',
            in: :header
          }
        },
        schemas: {
          Shop: {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a shop.'
              },
              name: {
                type: 'string',
                example: 'Jardin Local',
                description: 'Display name of a shop.'
              },
              slug: {
                type: 'string',
                example: 'jardin-local',
                description: 'Slug of a shop.'
              },
              products: {
                type: 'array',
                items: {
                  '$ref': '#/components/schemas/Product'
                },
                description: 'List of products.',
              }
            }
          },
          Product: {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a product.'
              },
              name: {
                type: 'string',
                example: 'Chaise longue',
                description: 'Display name of a product.'
              },
              slug: {
                type: 'string',
                example: 'chaise-longue',
                description: 'Slug of a product.'
              },
              description: {
                type: 'string',
                example: 'Chaise longue pour jardin extérieur.',
                description: 'Description of a product.'
              },
              category: {
                '$ref': '#/components/schemas/Category',
                description: 'Category of a product.'
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
              variants: {
                type: 'array',
                items: {
                  '$ref': '#/components/schemas/Variant'
                },
                description: 'List of variants.'
              }
            }
          },
          Category: {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a category.'
              },
              name: {
                type: 'string',
                example: 'Mobilier extérieur',
                description: 'Display name of a category.'
              }
            }
          },
          Variant: {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a variant.'
              },
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
                description: 'List of variant images urls'
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
            }
          },
          Characteristic: {
            type: 'object',
            properties: {
              name: {
                type: 'string',
                example: 'blue',
                description: 'Display name of a characteristic.'
              },
              type: {
                type: 'string',
                example: 'color',
                enum: ['color', 'size'],
                description: 'Type of a characteristic.'
              }
            },
            required: %w[name type]
          },
          GoodDeal: {
            type: 'object',
            properties: {
              startAt: {
                type: 'string',
                format: 'date',
                example: '20/01/2021',
                description: 'Start date of a good deal.'
              },
              endAt: {
                type: 'string',
                format: 'date',
                example: '16/02/2021',
                description: 'End date of a good deal.'
              },
              discount: {
                type: 'integer',
                example: '20',
                minimum: 1,
                maximum: 100,
                description: 'Discount amount of a good deal.'
              }
            },
            required: %w[startAt endAt discount]
          },
          Error: {
            type: 'object',
            properties: {
              status: {
                type: 'integer',
                example: 400,
                description: 'Status of an error.'
              },
              message: {
                type: 'string',
                example: 'Bad Request',
                description: 'Message of an error.'
              },
              detail: {
                type: 'string',
                example: 'The syntax of the query is incorrect.',
                description: 'Detail message of an error.'
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :json
end
