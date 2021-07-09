# frozen_string_literal: true

Dir["./spec/swagger/examples/*.rb"].each do |f|
  require f
end

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
          Shop: Examples::Shop.to_h,
          Address: Examples::Address.to_h,
          Schedule: Examples::Schedule.to_h,
          Product: Examples::Product.to_h,
          Category: Examples::Category.to_h,
          Variant: Examples::Variant.to_h,
          Characteristic: Examples::Characteristics.to_h,
          GoodDeal: Examples::GoodDeal.to_h,
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
          },
          Unauthorized: Examples::Errors::Unauthorized.new.error,
          BadRequest: Examples::Errors::BadRequest.new.error,
          InternalError: Examples::Errors::InternalError.new.error,
          UnprocessableEntity: Examples::Errors::UnprocessableEntity.new.error,
          Forbidden: Examples::Errors::Forbidden.new.error
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
