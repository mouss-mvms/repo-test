 require 'swagger_helper'

 RSpec.describe 'api/v1/variants', swagger_doc: 'v1/swagger.json', type: :request do
   path '/api/v1/auth/variants/{id}' do
     parameter name: 'id', in: :path, type: :integer, description: 'Unique identifier of the variant of a product.'
     parameter name: 'x-client-id', in: :header, type: :string, required: true

     patch('Update a variant') do
       tags 'Variants'
       consumes 'multipart/form-data'
       produces 'application/json'
       description 'Return the variant updated'
       security [{ authorization: [] }]

       parameter name: :variant, in: :body, content: :formData, schema: {
         type: :object,
         properties: {
           basePrice: { type: :number, example: 44.99, description: "Price of product's variant" },
           weight: { type: :number, example: 0.56, description: "Weight of product's variant (in Kg)" },
           quantity: { type: :integer, example: 9, description: "Stock of product's variant" },
           isDefault: { type: :boolean, example: true, description: "Tell if this variant is the product's default variant" },
           goodDeal: {
             type: :object,
             description: 'Set a good deal for the variant',
             properties: {
               startAt: { type: :string, example: "20/07/2021", description: "Date of start of good deal" },
               endAt: { type: :string, example: "27/07/2021", description: "Date of end of good deal" },
               discount: { type: :integer, example: 45, description: "Amount of discount (in %)" }
             },
           },
           characteristics: {
             type: :object,
             description: 'Set the characteristics of variant (Set as an array)',
             properties: {
               name: { type: :string, example: 'color', description: 'Name of characteristic' },
               value: { type: :string, example: 'Bleu', description: 'Value of characteristic' }
             }
           },
           'files[]': {
             type: :array,
             description: "Variant's pictures",
             items: {
               type: :string,
               format: :binary
             }
           }
         }
       }

       response(200, 'Successful') do
         schema V1::Examples::Response::Variant.to_h
         run_test!
       end

       response(400, 'Bad Request') do
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

       response(404, 'Not Found') do
         schema Examples::Errors::NotFound.new.error
         run_test!
       end
     end
   end
 end
