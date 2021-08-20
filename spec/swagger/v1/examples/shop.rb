module V1
  module Examples
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
            imageUrls: {
              type: :array,
              items: {
                type: :string,
                example: 'http://www.image.com/image.jpg'
              },
              description: 'Images of a shop'
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
            }
          }
        }
      end
    end
  end
end