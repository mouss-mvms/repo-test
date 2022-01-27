require 'swagger_helper'

RSpec.describe 'api/v1/citizens/products', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/citizens/{id}/products' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the citizen.'

    get('retrieve products of a citizen') do
      parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'
      parameter name: :sort_by, in: :query, schema: { type: :string, enum: %w[created_at-asc created_at-desc] }
      parameter name: :limit, in: :query, type: :integer, description: 'Number of desired object per page. (default: 16)'
      parameter name: :page, in: :query, type: :integer, description: 'Number of desired page. (default: 1)'

      tags 'Citizens'
      produces 'application/json'
      description 'Retrieve a product from a citizen.'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema(
          type: :object,
          properties: {
            products: { type: :array, items: { '$ref': '#/components/schemas/Product' } },
            page: { type: :integer, description: 'Search page number.', example: 2 },
            totalPages: { type: :integer, description: 'Total search page number.', example: 15 },
            totalCount: { type: :integer, description: "Total of citizen's products.", example: 250 }
          })
        run_test!
      end

      response(304, 'Not Modified') do
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

  path '/api/v1/auth/citizens/self/products' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    post('Create a product for a citizen.') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Return created product polling url.'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Air jordan", description: 'Name of product' },
          description: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          brand: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
          status: { type: :string, example: "submitted", description: 'Status of product', enum: ["online", "offline", "submitted", "draft_cityzen", "refused"] },
          sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
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
                imageIds: {
                  type: 'array',
                  maxItems: 5,
                  items: {
                    type: 'number'
                  },
                  example: [234, 45566, 345],
                  default: [],
                  description: 'List of product images ids (required if no imageUrls)'
                },
                imageUrls: {
                  type: :array,
                  maxItems: 5,
                  items: {
                    type: :string
                  },
                  example: [
                    'https://path/to/image1.jpg',
                    'https://path/to/image2.jpg'
                  ],
                  default: [],
                  description: 'List of product images urls (required if no imageIds)'
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
                }
              },
              required: %w[characteristics imageIds imageUrls]
            }
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[
          name
          characteristics
          shopId
          citizenAdvice
          variants
        ]

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

  path '/api/v1/auth/citizens/self/products/{id}' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true
    parameter name: 'id', in: :path, type: :string, required: true

    patch('Update a product') do
      tags 'Products'
      produces 'application/json'
      consumes 'application/json'
      description 'Update product'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: "Air jordan", description: 'Name of product' },
          brand: { type: :string, example: "Nike", description: 'Brand of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          citizenAdvice: { type: :string, example: "Ce produit est super, je recommande !", description: 'Citizen advice of product' },
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, example: 67, description: "Id of product's variant wanted to update (No id means new variant for the product)" },
                basePrice: { type: :number, example: 44.99, description: "Price of product's variant (Required if new variant)" },
                imageIds: {
                  type: 'array',
                  maxItems: 5,
                  items: {
                    type: 'number'
                  },
                  example: [234, 45566, 345],
                  default: [],
                  description: 'List of product images ids (required if no imageUrls)'
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
              },
            }
          }
        }
      }

      response(200, 'Successful') do
        schema V1::Examples::Response::Product.to_h
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
