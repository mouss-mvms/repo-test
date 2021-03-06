require 'swagger_helper'

RSpec.describe 'api/v1/products', swagger_doc: swagger_path(version: 1), type: :request do
  path '/api/v1/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'

    patch('Update a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Air jordan", description: 'Name of product' },
          description: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          brand: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          status: { type: :string, example: "online", description: 'Status of product' },
          sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          categoryId: { type: :integer, example: ENV['UNCLASSIFIED_CATEGORY_ID'], description: 'Category id of product' },
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, example: 4567, description: "Variant id." },
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
                externalVariantId: { type: :string, example: '67ty7', description: 'Id of variant saved by the provider' }
              },
            },
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit ?? coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' },
          provider: {
            type: :object,
            properties: {
              name: { type: :string, example: 'wynd', description: 'Name of the API Provider', enum: ['wynd'] },
              externalProductId: { type: :string, example: '33tr', description: 'ID of product saved by the provider' }
            },
            required: %w[name]
          }
        },
        required: %w[provider]
      }


      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/Product'
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

    end

    put('Update a product (offline)') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Air jordan", description: 'Name of product' },
          description: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          brand: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          status: { type: :string, example: "online", description: 'Status of product' },
          sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          citizenAdvice: { type: :string, example: 'Produit trouv?? un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: ENV['UNCLASSIFIED_CATEGORY_ID'], description: 'Category id of product' },
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :number, example: 12, description: "Unique identifier of a variant of the product." },
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
                provider: {
                  type: :object,
                  properties: {
                    name: { type: :string, example: 'wynd', description: 'Name of the provider'},
                    externalVariantId: { type: :string, example: '67ty7', description: 'Id of variant saved by the provider' }
                  }
                }
              },
              required: %w[basePrice weight quantity isDefault]
            }
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit ?? coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' },
          provider: {
            type: :object,
            properties: {
              name: { type: :string, example: 'wynd', description: 'Name of the API Provider', enum: ['wynd'] },
              externalProductId: { type: :string, example: '33tr', description: 'ID of product saved by the provider' }
            },
            required: %w[name]
          }
        },
        required: %w[id name description brand status sellerAdvice isService categoryId variants characteristics]
      }

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Product'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('Delete a product (offline)') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      security [{ authorization: [] }]

      response(204, 'OK') do
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    get('Retrieve a product') do
      parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'
      
      tags 'Products'
      produces 'application/json'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/Product'
        run_test!
      end

      response(304, 'Not Modified') do
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.', required: true
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    delete('Delete a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      security [{ authorization: [] }]

      response(204, 'Product deleted') do
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
    end
  end

  path '/api/v1/products' do
    post('Create a product (offline)') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return the product created'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Air jordan", description: 'Name of product' },
          description: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          brand: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          status: { type: :string, example: "online", description: 'Status of product' },
          sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          citizenAdvice: { type: :string, example: 'Produit trouv?? un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: ENV['UNCLASSIFIED_CATEGORY_ID'], description: 'Category id of product' },
          shopId: { type: :integer, example: 453, description: 'Shop id of product' },
          variants: {
            type: :array,
            items: {
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
                provider: {
                  type: :object,
                  properties: {
                    name: { type: :string, example: 'wynd', description: 'Name of the provider'},
                    externalVariantId: { type: :string, example: '67ty7', description: 'Id of variant saved by the provider' }
                  }
                }
              },
              required: %w[basePrice weight quantity isDefault]
            }
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit ?? coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' },
          provider: {
            type: :object,
            properties: {
              name: { type: :string, example: 'wynd', description: 'Name of the API Provider', enum: ['wynd'] },
              externalProductId: { type: :string, example: '33tr', description: 'ID of product saved by the provider' }
            },
            required: %w[name]
          }
        },
        required: %w[name description brand status sellerAdvice isService categoryId variants characteristics provider shopId]
      }

      response(201, 'Created') do
        schema type: :object, '$ref': '#/components/schemas/Product'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end
    end
  end

  path '/api/v1/product-jobs/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of product job.'
    get('Get job product informations') do
      tags 'Products'
      produces 'application/json'
      description 'Return the job product status'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object, properties: {
          status: {
            type: 'string',
            enum: ['queued', 'working', 'complete', 'failed', 'interrupted'],
            description: "Job status"
          },
          product_id: {
            type: 'integer',
            example: 1,
            description: "Unique identifier of a product"
          }
        }
        run_test!
      end

      response(404, 'Job not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
