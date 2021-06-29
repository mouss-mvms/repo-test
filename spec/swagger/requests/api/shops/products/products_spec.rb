require 'swagger_helper'

RSpec.describe 'api/shops/products', type: :request do

  path '/api/shops/{shop_id}/products' do
    # You'll want to customize the parameter types...
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    get('list products') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve all products from the given shop.'
      security [{authorization: []}]

      response(200, 'Successful') do
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
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end
  end

  path '/api/auth/shops/{shop_id}/products' do
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    post('create product') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a product in the given shop.'
      security [{authorization: []}]

      parameter name: 'X-client-id', in: :header

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
              isService: {
                  type: 'boolean',
                  example: false,
                  description: 'This product is a merchandise or a service.'
              },
              variants: {
                  type: 'array',
                  description: 'List of variants.',
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
                          imageUrls: {
                              type: 'array',
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
                      },
                      required: %w[basePrice quantity]
                  }
              }
          },
          required: %w[name]
      }
      response(201, 'Successful') do
        schema type: :object,
               properties: {
                   product: {'$ref': '#/components/schemas/Product'}
               }
        run_test!
      end
    end

  end

  path '/api/shops/{shop_id}/products/{id}' do
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired product.'

    get('show product') do
      tags 'Products'
      produces 'application/json'
      description 'Retrieve a single product from the given shop.'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                   product: {'$ref': '#/components/schemas/Product'}
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end
  end

  path '/api/auth/shops/{shop_id}/products/{id}' do
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired product.'

    put('update product') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Update a single product from the given shop. **You must provide all existing product attributes.**'
      security [{authorization: []}]

      parameter name: 'X-client-id', in: :header

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
              imageUrls: {
                  type: 'array',
                  example: [
                      'https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr',
                      'https://leserigraphe.com/wp-content/uploads/2019/10/Walker-Texas-Ranger.jpg'
                  ],
                  default: [],
                  description: 'List of product images urls'
              },
              isService: {
                  type: 'boolean',
                  example: false,
                  description: 'This product is a merchandise or a service.'
              },
              variants: {
                  type: 'array',
                  description: 'List of variants.',
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
                          imageUrls: {
                              type: 'array',
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
                      },
                      required: %w[basePrice quantity]
                  }
              }
          },
          required: %w[name description categoryId brand status sellerAdvice isService variants]
      }
      response(200, 'Successful') do
        schema type: :object,
               properties: {
                   product: {'$ref': '#/components/schemas/Product'}
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(500, 'An Error Happended') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end

    delete('delete product') do
      tags 'Products'
      description 'Delete a single product from the given shop.'
      security [{authorization: []}]

      parameter name: 'X-client-id', in: :header

      response(204, 'Successful') do
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(500, 'An Error Happended') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end
  end

  path '/api/shops/{shop_id}/products' do
    # You'll want to customize the parameter types...
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    post('create product offline') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a product in the given shop. (offline)'
      security [{authorization: []}]

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
                  description: 'List of variants.',
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
              }
          },
          required: %w[name]
      }
      response(201, 'Successful') do
        schema type: :object,
               properties: {
                   product: {'$ref': '#/components/schemas/Product'}
               }
        run_test!
      end
    end

  end

  path '/api/shops/{shop_id}/products/{id}' do
    parameter name: 'shop_id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired product.'

    put('update product offline') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Update a single product from the given shop. **You must provide all existing product attributes.**'
      security [{authorization: []}]

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
              imageUrls: {
                  type: 'array',
                  example: [
                      'https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr',
                      'https://leserigraphe.com/wp-content/uploads/2019/10/Walker-Texas-Ranger.jpg'
                  ],
                  default: [],
                  description: 'List of variant images urls'
              },
              isService: {
                  type: 'boolean',
                  example: false,
                  description: 'This product is a merchandise or a service.'
              },
              variants: {
                  type: 'array',
                  description: 'List of variants.',
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
                          imageUrls: {
                              type: 'array',
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
                      },
                      required: %w[basePrice quantity]
                  }
              }
          },
          required: %w[name description categoryId brand status sellerAdvice isService variants]
      }
      response(200, 'Successful') do
        schema type: :object,
               properties: {
                   product: {'$ref': '#/components/schemas/Product'}
               }
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(500, 'An Error Happended') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end

    delete('delete product offline') do
      tags 'Products'
      description 'Delete a single product from the given shop.'
      security [{authorization: []}]

      response(204, 'Successful') do
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(401, 'Unauthorized') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end

      response(500, 'An Error Happended') do
        schema type: :object,
               properties: {
                   error: {'$ref': '#/components/schemas/Error'}
               }
        run_test!
      end
    end
  end

end
