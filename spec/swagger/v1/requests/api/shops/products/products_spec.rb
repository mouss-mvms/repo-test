require 'swagger_helper'

RSpec.describe 'api/v1/shops/products', swagger_doc: 'v1/swagger.json', type: :request do

  path '/api/v1/auth/shops/self/products' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    post('Create a product for a shop.') do
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
          status: { type: :string, example: "online", description: 'Status of product', enum: ["online", "offline", "submitted", "draft_cityzen", "refused"] },
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
                  description: 'List of product images ids'
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
              required: %w[basePrice weight quantity isDefault]
            }
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
        },
        required: %w[name description brand status sellerAdvice isService categoryId variants characteristics shopId]
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

    get("Retrieve products' shop") do
      tags 'Products'
      produces 'application/json'
      security [{ authorization: [] }]

      parameter name: :status, in: :query, schema: { type: :string, enum: [:offline, :online, :submitted] }
      parameter name: :name, in: :query
      parameter name: :category, in: :query
      parameter name: :page, in: :query, description: 'Set as 1 if not set'
      parameter name: :limit, in: :query, description: 'Set as 15 if not set'
      parameter name: :sortBy, in: :query,  schema: { type: :string, enum: [:created_at_desc, :created_at_asc] }

      response(200, 'Successful') do
        schema type: :object,
               properties:{
                 products: {
                   type: :array,
                   items: { '$ref': '#/components/schemas/Product' }
                 },
                 page: {
                   type: :integer,
                   example: 1,
                   description: "Current page of result"
                 },
                 totalPages: {
                   type: :integer,
                   example: 1,
                   description: "Total number of pages for result"
                 },
                 totalCount: {
                   type: :integer,
                   example: 1,
                   description: "Total products' count for the shop"
                 },
               }
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

  path '/api/v1/auth/shops/self/products/{id}' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true
    parameter name: 'id', in: :path, type: :string, required: true

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
          brand: { type: :string, example: "Nike", description: 'Brand of product' },
          status: { type: :string, example: "online", description: 'Status of product', enum: ["online", "offline", "submitted", "draft_cityzen", "refused"] },
          sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
          isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
          categoryId: { type: :integer, example: ENV['UNCLASSIFIED_CATEGORY_ID'], description: 'Category id of product' },
          variants: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer, example: 67, description: "Id of product's variant wanted to update (No id means new variant for the product)" },
                basePrice: { type: :number, example: 44.99, description: "Price of product's variant (Required if new variant)" },
                weight: { type: :number, example: 0.56, description: "Weight of product's variant (in Kg) (Required if new variant)" },
                quantity: { type: :integer, example: 9, description: "Stock of product's variant (Required if new variant)" },
                isDefault: { type: :boolean, example: true, description: "Tell if this variant is the product's default variant (Required if new variant)" },
                imageIds: {
                  type: 'array',
                  maxItems: 5,
                  items: {
                    type: 'number'
                  },
                  example: [234, 45566, 345],
                  default: [],
                  description: 'List of product images ids'
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
                  description: "Characteristics of variant (Required if new variant)",
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
            }
          },
          origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
          allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
          composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' }
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

  path '/api/v1/auth/shops/self/products/{id}/reject' do
    parameter name: 'X-client-id', in: :header, type: :string, required: true
    parameter name: 'id', in: :path, type: :string, required: true

    post('Reject a product') do
      tags 'Products'
      produces 'application/json'
      security [{ authorization: [] }]

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
