require 'swagger_helper'

RSpec.describe 'api/shops', type: :request do
  path '/api/shops/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    get("shop informations") do
      tags 'Shops'
      produces 'application/json'
      description 'Retrieve shop informations'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/Shop'}]
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/NotFound'}]
        run_test!
      end
    end
  end

  path '/api/auth/shops/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    put("Update Shop") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Update a shop'
      security [{authorization: []}]
      parameter name: 'X-client-id', in: :header, type: :string

      parameter name: :shop, in: :body, schema: {
        type: 'object',
        properties: {
          name: {
            type: 'string',
            example: 'Jardin Local',
            description: 'Display name of a shop.'
          },
          imageUrls: {
            type: :array,
            items: {
              type: :string,
              example: 'http://www.image.com/image.jpg'
            },
            description: 'Images of a shop'
          },
          email: {
            type: 'string',
            example: "L'email d'une boutique",
            description: "Shop's email"
          },
          description: {
            type: 'string',
            example: "La description d'une boutique",
            description: "Shop's description"
          },
          baseline: {
            type: 'string',
            example: "Ma boutique est top",
            description: "Shop's baseline"
          },
          siret: {
            type: 'string',
            example: "75409821800029",
            description: "Shop's siret"
          },
          facebookLink: {
            type: 'string',
            example: 'http://www.facebook.com/boutique',
            description: "Shop's facebook link"
          },
          instagramLink: {
            type: 'string',
            example: 'http://www.instagram.com/boutique',
            description: "Shop's instagram link"
          },
          websiteLink: {
            type: 'string',
            example: 'http://www.boutique.com/',
            description: "Shop's website link"
          },
          address: {
            '$ref': '#/components/schemas/Address',
            description: "Shop's address"
          }
        },
        required: %w[id]
      }

      response(201, 'Created') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/Shop'}]
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end
    end
  end

  path '/api/auth/shops' do
    post("Create Shop") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a shop'
      security [{authorization: []}]
      parameter name: 'X-client-id', in: :header, type: :string

      parameter name: :shop, in: :body, schema: {
        type: 'object',
        properties: {
          name: {
            type: 'string',
            example: 'Jardin Local',
            description: 'Display name of a shop.'
          },
          imageUrls: {
            type: :array,
            items: {
              type: :string,
              example: 'http://www.image.com/image.jpg'
            },
            description: 'Images of a shop'
          },
          email: {
            type: 'string',
            example: "L'email d'une boutique",
            description: "Shop's email"
          },
          description: {
            type: 'string',
            example: "La description d'une boutique",
            description: "Shop's description"
          },
          baseline: {
            type: 'string',
            example: "Ma boutique est top",
            description: "Shop's baseline"
          },
          siret: {
            type: 'string',
            example: "75409821800029",
            description: "Shop's siret"
          },
          facebookLink: {
            type: 'string',
            example: 'http://www.facebook.com/boutique',
            description: "Shop's facebook link"
          },
          instagramLink: {
            type: 'string',
            example: 'http://www.instagram.com/boutique',
            description: "Shop's instagram link"
          },
          websiteLink: {
            type: 'string',
            example: 'http://www.boutique.com/',
            description: "Shop's website link"
          },
          address: {
            '$ref': '#/components/schemas/Address',
            description: "Shop's address"
          }
        },
        required: %w[name, address, email, siret]
      }

      response(201, 'Created') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/Shop'}]
        run_test!
      end

      response(400, 'Bad request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end
    end
  end
end
