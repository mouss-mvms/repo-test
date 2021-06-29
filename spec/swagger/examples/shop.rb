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
          image_urls: {
            type: 'array',
            example: ['http://www.image.com/image.jpg'],
            description: 'Images of shop'
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
          facebook_link: {
            type: 'string',
            example: 'http://www.facebook.com/boutique',
            description: "Shop's facebook link"
          },
          instagram_link: {
            type: 'string',
            example: 'http://www.instagram.com/boutique',
            description: "Shop's instagram link"
          },
          website_link: {
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
