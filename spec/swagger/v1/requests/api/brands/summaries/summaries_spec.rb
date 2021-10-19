require "spec_helper"

RSpec.describe "api/v1/brands/summaries", swagger_doc: "v1/swagger.json", type: :request do
  path '/api/v1/brands/summaries/search' do
    post('Return brand-summaries list.') do
      tags 'Brands'
      consumes 'application/json'
      produces 'application/json'
      description 'Return brand-summaries list'
      security [{ authorization: [] }]

      parameter name: :shops, in: :body, schema: {
        type: :object,
        properties: {
          q: { type: :string, example: 'rebok', description: 'Query for search.' },
          sortBy: { type: :string, enum: ["products-count"] },
          page: { type: :string, example: '2', description: 'Search page number.' }
        }
      }

      response(200, 'Successful') do
        schema type: :object, '$ref': '#/components/schemas/BrandSearch'
        run_test!
      end

    end
  end
end