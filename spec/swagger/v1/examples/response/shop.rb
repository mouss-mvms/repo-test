module V1
  module Examples
    module Response
      class Shop
        def self.to_h
          {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a shop.'
              },
              name: {
                type: 'string',
                example: 'Jardin Local',
                description: 'Display name of a shop.'
              },
              slug: {
                type: 'string',
                example: 'jardin-local',
                description: 'Slug of a shop.'
              },
              images: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 42 },
                    originalUrl: { type: :string, example: 'https://path/to/original-image.jpg' },
                    miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg' },
                    thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg' },
                    squareUrl: { type: :string, example: 'https://path/to/square-format.jpg' },
                    wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg' }
                  }
                },
                description: 'Images of a shop'
              },
              avatar: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 42 },
                  originalUrl: { type: :string, example: 'https://path/to/original-image.jpg' },
                  miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg' },
                  thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg' },
                  squareUrl: { type: :string, example: 'https://path/to/square-format.jpg' },
                  wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg' }
                },
                description: "Avatar image of a shop"
              },
              cover: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 42 },
                  originalUrl: { type: :string, example: 'https://path/to/original-image.jpg' },
                  miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg' },
                  thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg' },
                  squareUrl: { type: :string, example: 'https://path/to/square-format.jpg' },
                  wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg' }
                },
                description: "Cover image of a shop"
              },
              mainImage: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 42 },
                  originalUrl: { type: :string, example: 'https://path/to/original-image.jpg' },
                  miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg' },
                  thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg' },
                  squareUrl: { type: :string, example: 'https://path/to/square-format.jpg' },
                  wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg' }
                },
                description: "Main image of a shop"
              },
              description: {
                type: 'string',
                example: "La description d'une boutique",
                description: "Shop's description"
              },
              siret: {
                type: 'string',
                example: "75409821800029",
                description: "Shop's siret"
              },
              email: {
                type: 'string',
                example: "boutique@email.com",
                description: "Shop's email"
              },
              mobileNumber: {
                type: 'string',
                example: "0677777777",
                description: "Shop's mobile number"
              },
              baseline: {
                type: 'string',
                example: "Ma boutique est top",
                description: "Shop's baseline"
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
              },
              webUri: {
                type: 'string',
                example: 'bordeaux/boutique/ma_boutique_slug',
                description: "MVMS web uri"
              },
              lowestProductPrice: {
                type: :number,
                example: 23.55,
                description: "Shop's lowest product price"
              },
              highestProductPrice: {
                type: :number,
                example: 150000000.0,
                description: "Shop's highest product price"
              }
            }
          }
        end
      end
    end
  end
end
