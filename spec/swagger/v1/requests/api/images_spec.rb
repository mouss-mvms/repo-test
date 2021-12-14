require "swagger_helper"

RSpec.describe "api/v1/auth/images", swagger_doc: "v1/swagger.json", type: :request do
  path "/api/v1/auth/images" do
    parameter name: 'X-client-id', in: :header, type: :string, required: true

    post("Upload image files and returns image ids") do
      tags "Images"
      consumes "multipart/form-data"
      produces "application/json"
      description "Return image ids"
      security [{ authorization: [] }]

      parameter name: :variant, in: :body, content: :formData, schema: {
        type: :object,
        properties: {
          'files[]': {
            type: :array,
            description: "Image's pictures",
            items: {
              type: :string,
              format: :binary,
            },
          },
        },
      }

      response(201, "Created") do
        schema type: "array",
               items: {
                 '$ref': '#/components/schemas/Image'
               }
        run_test!
      end

      response(400, "Bad Request") do
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
end
