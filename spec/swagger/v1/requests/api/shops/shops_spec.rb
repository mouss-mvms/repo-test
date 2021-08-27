require 'swagger_helper'

RSpec.describe 'api/v1/shops', swagger_doc: 'v1/swagger.json', type: :request do
  path '/api/v1/shop-summaries' do
    parameter name: :location, in: :query, type: :string, required: true, description: 'Territory or city slug'
    parameter name: :q, in: :query, type: :string, description: 'Query for search.'
    parameter name: :categories, in: :query, type: :string, description: 'Categories slugs concatened with double "_" if more than one'
    parameter name: :page, in: :query, type: :string, description: 'Number of the researches page'
    parameter name: :perimeter, in: :query, schema: {
      type: :string,
      enum: [
        "around_me",
        "all"
      ]
    }
    parameter name: :more, in: :query
    parameter name: :services, in: :query, type: :string, description: 'Services slugs concatened with double "_" if more than one'

    get("List of shop summaries") do
      tags 'Shops'
      produces 'application/json'
      description 'List of shop summaries'
      security [{authorization: []}]

      response(200, 'Successful') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/ShopSummary'}]
        run_test!
      end

      response(400, 'Bad Request') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/BadRequest'}]
        run_test!
      end

      response(404, 'Not found') do
        schema type: :object, oneOf: [{'$ref': '#/components/schemas/NotFound'}]
        run_test!
      end
    end
  end

  path '/api/v1/shops/{id}' do
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

  path '/api/v1/auth/shops/{id}' do
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

  path '/api/v1/auth/shops' do
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

  path '/api/v1/shops' do
    get('get shops') do
      tags 'Shops'
      produces 'application/json'
      description 'Get a list of shops'
      security [{authorization: []}]

      parameter name: :q, in: :query, type: :string, description: 'Search query'
      parameter name: :location, in: :query, type: :string, description: 'City or territory slug'
      parameter name: :categories, in: :query, type: :string, description: 'Categories slugs concatened with double "_" if more than one.', example: "vin-et-spiritueux/aperitif-et-spiritueux/rhum__maison-et-bricolage/cuisine"
      parameter name: :perimeter, in: :query, type: :string, description: " 'around_me' : dans mon département, 'all' : dans toute la France"
      parameter name: :services, in: :query,type: :string, example: "livraison-par-la-poste__click-collect", description: 'Service slugs concatened with double "_" if more than one.'
      parameter name: :page, in: :query, type: :string, description: 'Number of the researches page'

      response(200, 'Ok') do
        schema type: :array, items: {'$ref': '#/components/schemas/Shop'}
        run_test!
      end
    end
  end
end
