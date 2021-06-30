module Examples
  class Product
    def self.to_h
      {
        type: 'object',
        properties: {
          id: {
            type: 'integer',
            example: 1,
            description: 'Unique identifier of a product.'
          },
          name: {
            type: 'string',
            example: 'Chaise longue',
            description: 'Display name of a product.'
          },
          slug: {
            type: 'string',
            example: 'chaise-longue',
            description: 'Slug of a product.'
          },
          description: {
            type: 'string',
            example: 'Chaise longue pour jardin extérieur.',
            description: 'Description of a product.'
          },
          category: {
            '$ref': '#/components/schemas/Category',
            description: 'Category of a product.'
          },
          brand: {
            type: 'string',
            example: 'Lafuma',
            description: 'Brand of a product.'
          },
          status: {
            type: 'string',
            example: 'online',
            default: 'not_online',
            enum: ['not_online', 'online', 'draft_cityzen', 'submitted', 'refused'],
            description: 'Status of a product.'
          },
          sellerAdvice: {
            type: 'string',
            example: 'Nettoyez votre mobilier à l’eau claire ou savonneuse sans détergent.',
            description: 'Seller advice of a product'
          },
          isService: {
            type: 'boolean',
            example: false,
            description: 'This product is a merchandise or a service.'
          },
          imageUrls: {
            type: 'array',
            items: {
              type: 'string'
            },
            example: [
              'https://static.wikia.nocookie.net/charabattles/images/e/eb/Chuck_norris.jpg/revision/latest?cb=20170412123612&path-prefix=fr',
              'https://leserigraphe.com/wp-content/uploads/2019/10/Walker-Texas-Ranger.jpg'
            ],
            default: [],
            description: 'List of product images urls'
          },
          variants: {
            type: 'array',
            items: {
              '$ref': '#/components/schemas/Variant'
            },
            description: 'List of variants.'
          },
          citizenAdvice: {
            type: 'string',
            example: 'Très belle chaussure, confortable et indémodable ! Elle vous donnera un look sympa, idéal avec un jean slim. Attention de bien prévoir une taille au-dessus, chausse un peu petit.',
            description: 'Citizen advice of a product'
          }
        }
      }
    end
  end
end
