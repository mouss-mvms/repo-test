require "swagger_helper"

RSpec.describe "api/v1/images", swagger_doc: "v1/swagger.json", type: :request do
  path "/api/v1/images" do
    post("Upload image files and returns image urls") do
      tags "Images"
      consumes "multipart/form-data"
      produces "application/json"
      description "Return the variant updated"
      security [{ authorization: [] }]

      parameter name: :variant, in: :body, content: :formData, schema: {
        type: :object,
        properties: {
          'files[]': {
            type: :array,
            description: "Variant's pictures",
            items: {
              type: :string,
              format: :binary,
            },
          },
        },
        required: %w[files],
      }

      response(200, "Successful") do
        schema type: "array",
               items: {
                 type: "string",
               },
               example: [
                 "https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr",
                 "https://leserigraphe.com/wp-content/uploads/2019/10/Walker-Texas-Ranger.jpg",
               ]

        run_test!
      end

      response(400, "Bad Request") do
        schema Examples::Errors::BadRequest.new.error
        run_test!
      end
    end
  end
end
