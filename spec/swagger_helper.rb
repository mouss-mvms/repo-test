# frozen_string_literal: true

Dir["./spec/swagger/v*/examples/*.rb"].each do |f|
  require f
end

require './spec/swagger/examples/errors.rb'
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
        version: '1.0.0',
        description: 'Ma Ville Mon Shopping Catalog API'
      },
      paths: {},
      servers: [
        {
          url: ENV['API_BASE_URL'].to_s
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
          Shop: V1::Examples::Shop.to_h,
          Address: V1::Examples::Address.to_h,
          Schedule: V1::Examples::Schedule.to_h,
          Product: V1::Examples::Product.to_h,
          ProductSummary: V1::Examples::ProductSummary.to_h,
          ShopSummary: V1::Examples::ShopSummary.to_h,
          Category: V1::Examples::Category.to_h,
          Variant: V1::Examples::Variant.to_h,
          Characteristic: V1::Examples::Characteristics.to_h,
          GoodDeal: V1::Examples::GoodDeal.to_h,
          Unauthorized: V1::Examples::Errors::Unauthorized.new.error,
          BadRequest: V1::Examples::Errors::BadRequest.new.error,
          InternalError: V1::Examples::Errors::InternalError.new.error,
          UnprocessableEntity: V1::Examples::Errors::UnprocessableEntity.new.error,
          Forbidden: V1::Examples::Errors::Forbidden.new.error,
          NotFound: V1::Examples::Errors::NotFound.new.error
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
