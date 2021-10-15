require "spec_helper"

RSpec.describe "api/v1/products/summaries", swagger_doc: "v1/swagger.json", type: :request do
  path '/api/v1/products/summaries' do
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

  path '/api/v1/products/summaries/search' do
    post('Return product-summaries list with filters') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'
      description 'Return product-summaries list with filters'
      security [{ authorization: [] }]

      parameter name: :product, in: :body, schema: {
        type: :object,
        properties: {
          location: { type: :string, example: "bordeaux", description: 'Territory or city slug.' },
          q: { type: :string, example: "Chaussures", description: 'Query for search.' },
          categories: { type: :string, example: "homme", description: 'Categories slugs concatened with double "_" if more than one.' },
          prices: { type: :string, example: "1__100", description: 'Prices range' },
          sharedProducts: { type: :boolean, description: "Only shared products", example: false },
          services: { type: :string, example: "livraison-par-la-poste__livraison-france-metropolitaine", description: 'Service slugs concatened with double "_" if more than one.' },
          sortBy: {
            type: :string,
            enum: ["price-asc", "price-desc", "newest"]
          },
          page: { type: :string, example: '1', description: 'Search page number.' },
          more: { type: :boolean, description: 'Increase research perimeter scope' },

        }
      }
      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/ProductSearch'
        run_test!
      end
    end
  end

end
