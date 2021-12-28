require 'swagger_helper'

RSpec.describe 'api/v1/shops', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shops/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    get("shop informations") do
      parameter name: 'If-None-Match', in: :header, type: :string, description: 'Etag checker.'
      tags 'Shops'
      produces 'application/json'
      description 'Retrieve shop informations'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/Shop'
        run_test!
      end

      response(304, 'Not Modified') do
        run_test!
      end

      response(404, 'Not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/shops/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'Unique identifier of the desired shop.'

    put("Update Shop") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Update a shop'
      security [{authorization: []}]
      parameter name: 'X-client-id', in: :header, type: :string, required: true

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
          mobileNumber: {
            type: 'string',
            example: "0677777777",
            description: "Shop's mobile number"
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
          address: V1::Examples::Request::Address.to_h,
          avatarImageId: {
            type: 'integer',
            example: 14,
            description: "Image id wanted to be the shop's avatar image"
          },
        },
        required: %w[id name address email mobileNumber siret]
      }

      response(200, 'Succesful') do
        schema type: :object, '$ref': '#/components/schemas/Shop'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/shops' do
    post("Create Shop") do
      tags 'Shops'
      consumes 'application/json'
      produces 'application/json'
      description 'Create a shop'
      security [{authorization: []}]
      parameter name: 'X-client-id', in: :header, type: :string, required: true

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
          mobileNumber: {
            type: 'string',
            example: "0677777777",
            description: "Shop's mobile number"
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
        required: %w[name address email mobileNumber siret]
      }

      response(201, 'Created') do
        schema type: :object, '$ref': '#/components/schemas/Shop'
        run_test!
      end

      response(400, 'Bad request') do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end
    end
  end
end
