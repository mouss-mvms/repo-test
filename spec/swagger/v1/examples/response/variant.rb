module V1
  module Examples
    module Response
      class Variant
        def self.to_h
          {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a variant.'
              },
              basePrice: {
                type: 'number',
                format: 'double',
                example: 20.50,
                description: 'Base price of a variant.'
              },
              weight: {
                type: 'number',
                format: 'double',
                nullable: true,
                example: 20.50,
                description: 'Weight in grams of a variant.'
              },
              quantity: {
                type: 'integer',
                example: 20,
                description: 'Quantity in stock of a variant.'
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
                description: 'List of variant images urls'
              },
              isDefault: {
                type: 'boolean',
                default: false,
                description: 'Default state of a variant.'
              },
              goodDeal: {
                '$ref': '#/components/schemas/GoodDeal',
                description: 'Good deal of a variant.'
              },
              characteristics: {
                type: 'array',
                items: {
                  '$ref': '#/components/schemas/Characteristic'
                },
                description: 'List of characteristics.'
              },
              externalVariantId: { type: :string, example: '67ty7', description: 'Id of variant saved by the provider' }
            }
          }
        end
      end
    end
  end
end
