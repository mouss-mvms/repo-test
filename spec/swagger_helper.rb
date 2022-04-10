# frozen_string_literal: true

%w[request response].each do |folder|
  Dir["./spec/swagger/v*/examples/#{folder}/*.rb"].sort.each do |f|
    require f
  end
end

%w[brands products shops searches].each do |folder|
  Dir["./spec/swagger/v*/examples/response/#{folder}/*.rb"].sort.each do |f|
    require f
  end
end

require './spec/swagger/examples/errors.rb'


require 'rails_helper'

def swagger_path(version:)
  path = "v#{version.to_s}"
  path += "/#{Rails.env}" unless Rails.env.test? || Rails.env.production?
  path += "/swagger.json"
  return path
end

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
    swagger_path(version:1) => {
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
          Address: V1::Examples::Response::Address.to_h,
          BrandSummary: V1::Examples::Response::BrandSummary.to_h,
          BrandSearch: V1::Examples::Response::Brands::Search.to_h,
          Category: V1::Examples::Response::Category.to_h,
          Characteristic: V1::Examples::Response::Characteristics.to_h,
          Citizen: V1::Examples::Response::Citizen.to_h,
          Delivery: V1::Examples::Response::Delivery.to_h,
          GoodDeal: V1::Examples::Response::GoodDeal.to_h,
          Image: V1::Examples::Response::Image.to_h,
          Product: V1::Examples::Response::Product.to_h,
          Review: V1::Examples::Response::Review.to_h,
          Schedule: V1::Examples::Response::Schedule.to_h,
          ProductSearch: V1::Examples::Response::Products::Search.to_h,
          ProductSummary: V1::Examples::Response::ProductSummary.to_h,
          Selection: V1::Examples::Response::Selection.to_h,
          Shop: V1::Examples::Response::Shop.to_h,
          ShopSearch: V1::Examples::Response::Shops::Search.to_h,
          ShopSummary: V1::Examples::Response::ShopSummary.to_h,
          Tag: V1::Examples::Response::Tag.to_h,
          Variant: V1::Examples::Response::Variant.to_h,
          Errors: Examples::Errors::Error.new(message_example: "Bad Request", status_example: 400, detail_example: "The syntax of the query is incorrect.").error
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
