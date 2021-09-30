require 'swagger_helper'

RSpec.describe 'api/v1/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/product-summaries' do
    get('Return product-summaries list') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return product-summaries list'
      security [{ authorization: [] }]

      parameter name: :location, in: :query, type: :string, description: 'Territory or city slug.'
      parameter name: :q, in: :query, type: :string, description: 'Query for search.'
      parameter name: :categories, in: :query, type: :string, description: 'Categories slugs concatened with double "_" if more than one.'
      parameter name: :prices, in: :query, type: :string, description: 'Prices range'
      parameter name: :services, in: :query, type: :string, description: 'Service slugs concatened with double "_" if more than one.'
      parameter name: :sort_by, in: :query, schema: {
        type: :string,
        enum: [
          "price-asc",
          "price-desc",
          "newest"
        ]
      }
      parameter name: :page, in: :query, type: :string, description: 'Search page number.'
      parameter name: :more, in: :query, type: :boolean, description: 'Increase research perimeter scope'

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/ProductSummary'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end
    end
  end

  path '/api/v1/product-summaries/search' do
    post('Return product-summaries list with filters') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return product-summaries list with filters'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "Bordeaux", description: 'Territory or city slug.' },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          categories: { type: :string, example: "homme", description: 'Categories slugs concatened with double "_" if more than one.' },
          prices: { type: :string, example: "1__100", description: 'Prices range' },
          services: { type: :string, example: "livraison-par-la-poste__livraison-france-metropolitaine", description: 'Service slugs concatened with double "_" if more than one.' },
          sort_by: {
            type: :string,
            enum: ["price-asc", "price-desc", "newest"]
          },
          page: { type: :string, example: '1', description: 'Search page number.' },
          more: { type: :boolean, description: 'Increase research perimeter scope' },

        }
      }
      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Search'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end

      response(404, 'Not Found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'

    put('Update a product (offline)') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return the product updated'
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
          citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: 4, description: 'Category id of product' },
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
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
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
      description 'Delete a product'
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
      tags 'Products'
      produces 'application/json'
      description 'Retrieve a product'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/Product'
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/products/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the product.'
    parameter name: 'X-client-id', in: :header, type: :string

    put('Update a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return the product updated'
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
          citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: 4, description: 'Category id of product' },
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
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
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

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('Delete a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Delete a product'
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

  path '/api/v1/auth/products' do
    parameter name: 'X-client-id', in: :header, type: :string

    post('Create a product') do
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
          citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: 4, description: 'Category id of product' },
          shopId: { type: :integer, example: 453, description: 'Shop id of product' },
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
            type: :array,
            items: {
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
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]

      }

      response(202, 'Accepted') do
        schema type: :object, properties: { url: { type: 'string', example: "https://exempleurl/api/products/status/10aad2e35138aa982e0d848a", description: "Url polling" } }
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
          citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
          categoryId: { type: :integer, example: 4, description: 'Category id of product' },
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
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
      }

      response(202, 'Accepted') do
        schema type: :object, properties: { url: { type: 'string', example: "https://exempleurl/api/products/status/10aad2e35138aa982e0d848a", description: "Url polling" } }
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
