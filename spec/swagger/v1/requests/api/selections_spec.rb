require 'swagger_helper'

RSpec.describe 'api/v1/selections', swagger_doc: swagger_path(version: 1), type: :request do
  path '/api/v1/auth/selections' do
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    post('create a selection') do
      tags 'Selections'
      produces 'application/json'
      consumes 'application/json'
      description 'Create a selection.'
      security [{ authorization: [] }]

      parameter name: :selection, in: :body, schema: {
        type: :object,
        description: 'Route to create a selection',
        properties: {
          name: { type: :string, example: "voiture", description: 'Selection name.' },
          description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
          tagIds: {
            type: :array,
            items: { type: :integer, example: 12, description: 'Tag id.' }
          },
          startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
          endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
          homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
          event: { type: :boolean, example: false, description: 'Selection is an event.' },
          state: {
            type: :string,
            enum: ["disabled", "active"]
          },
          imageId: { type: :integer, example: 1, description: "Required if no imageUrl"},
          imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg", description: "Required if no imageId"},
          coverId: { type: :integer, example: 1 },
          coverUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" },
          promoted: { type: :boolean, example: false, description: 'Selection is promoted.' },
          longDescription: {
            type: :text,
            example: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
              Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
              Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.",
            description: "Unlimited characters description"
          }
        },
        required: %w[name description]
      }

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
        run_test!
      end

      response(400, 'Bad request') do
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/admin/selections' do
    get('List all selections for admin users.') do
      parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
      parameter name: :page, in: :query, type: :integer, example: 1, description: 'Number of desired page.', required: true
      parameter name: :promoted, in: :query, schema: { type: :string, enum: ["true", "false"], description: 'Selection is promoted' }
      parameter name: :limit, in: :query, type: :integer, description: 'Number of desired object per page. (default: 16)'

      tags 'Selections'
      produces 'application/json'
      consumes 'application/json'
      description 'List all selections for admin users.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema type: :object,
               properties: {
                 selections: {
                   type: :array,
                   items: { '$ref': '#/components/schemas/Selection' }
                 },
                 page: { type: :integer, example: 1 },
                 totalCount: { type: :integer, example: 250 },
                 totalPages: { type: :integer, example: 19 }
               }
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

  path '/api/v1/auth/selections/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the selection.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    patch('update a selection') do
      tags 'Selections'
      produces 'application/json'
      consumes 'application/json'
      description 'Update a selection.'
      security [{ authorization: [] }]

      parameter name: :selection, in: :body, schema: {
        type: :object,
        description: 'Route to update a selection',
        properties: {
          name: { type: :string, example: "voiture", description: 'Selection name.' },
          description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
          tagIds: {
            type: :array,
            items: { type: :integer, example: 12, description: 'Tag id.' }
          },
          startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
          endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
          homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
          event: { type: :boolean, example: false, description: 'Selection is an event.' },
          state: {
            type: :string,
            enum: ["disabled", "active"]
          },
          imageId: { type: :integer, example: 1 },
          imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" },
          coverId: { type: :integer, example: 1 },
          coverUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" },
          promoted: { type: :boolean, example: false, description: 'Selection is promoted.' },
          longDescription: {
            type: :text,
            example: "My money's in that office, right? If she start giving me some bullshit about it ain't there, and we got to go someplace else and get it, I'm gonna shoot you in the head then and there. Then I'm gonna shoot that bitch in the kneecaps, find out where my goddamn money is. She gonna tell me too. Hey, look at me when I'm talking to you, motherfucker. You listen: we go in there, and that nigga Winston or anybody else is in there, you the first motherfucker to get shot. You understand?
              Look, just because I don't be givin' no man a foot massage don't make it right for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass, 'cause I'll kill the motherfucker, know what I'm sayin'?
              Now that there is the Tec-9, a crappy spray gun from South Miami. This gun is advertised as the most popular gun in American crime. Do you believe that shit? It actually says that in the little book that comes with it: the most popular gun in American crime. Like they're actually proud of that shit.",
            description: "Unlimited characters description"
          }
        }
      }

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
        run_test!
      end

      response(400, 'Bad request') do
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('delete a selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Delete a selection.'
      security [{ authorization: [] }]

      response(204, 'Successful') do
        run_test!
      end

      response(400, 'Bad request') do
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/admin/selections/{id}' do
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true
    parameter name: :id, in: :path, type: :integer, description: "Unique identifier of a selection."
    get('Returns a selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Returns a selection.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema '$ref': '#/components/schemas/Selection'
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

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/selections' do
    parameter name: :page, in: :query, type: :integer, example: 1, description: 'Number of desired page.', required: true

    get('Lists all the online selections') do
      tags 'Selections'
      produces 'application/json'
      description 'Lists all the online selections.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 selections: {
                   type: :array,
                   items: { '$ref': '#/components/schemas/Selection' }
                 },
                 page: { type: :integer, example: 1 },
                 totalPages: { type: :integer, example: 19 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/selections/{id}' do
    parameter in: :path, name: :id, type: :integer, description: 'Unique identifier of a selection.'
    get('Returns an online selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Returns an online selection.'
      security [{ authorization: [] }]

      response(200, 'Successful') do
        schema '$ref': '#/components/schemas/Selection'
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end

  path '/api/v1/auth/selections/{selection_id}/products/{id}' do
    parameter name: :selection_id, in: :path, type: :integer, description: 'Unique identifier of the selection.', required: true
    parameter name: :id, in: :path, type: :integer, description: 'Unique identifier of the product.', required: true
    parameter name: 'x-client-id', in: :header, type: :string, description: 'Auth token of user', required: true

    post('Add a product to a selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Add a product to a selection.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end

    delete('Remove a product to a selection') do
      tags 'Selections'
      produces 'application/json'
      description 'Remove a product to a selection.'
      security [{ authorization: [] }]

      response(200, 'successful') do
        schema type: :object, '$ref': '#/components/schemas/Selection'
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

      response(404, 'Selection not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end

      response(404, 'Product not found') do
        schema Examples::Errors::NotFound.new.error
        run_test!
      end
    end
  end
end
