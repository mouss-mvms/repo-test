module V1
  module Examples
    module Request
      class Product
        def self.to_h
          {
            type: :object,
            properties: {
              name: {type: :string, example: "Air jordan", description: 'Name of product'},
              description: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
              brand: {type: :string, example: "Chaussures trop bien", description: 'Description of product'},
              status: {type: :string, example: "online", description: 'Status of product', enum: ["online", "offline", "submitted", "draft_cityzen", "refused"]},
              sellerAdvice: {type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product'},
              isService: {type: :boolean, example: false, description: 'Tell if the product is a service'},
              citizenAdvice: {type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product'},
              categoryId: {type: :integer, example: ENV['UNCLASSIFIED_CATEGORY_ID'], description: 'Category id of product'},
              shopId: {type: :integer, example: 453, description: 'Shop id of product'},
=begin
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
=end
              variants: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    basePrice: {type: :number, example: 44.99, description: "Price of product's variant"},
                    weight: {type: :number, example: 0.56, description: "Weight of product's variant (in Kg)"},
                    quantity: {type: :integer, example: 9, description: "Stock of product's variant"},
                    isDefault: {type: :boolean, example: true, description: "Tell if this variant is the product's default variant"},
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
                    goodDeal: {
                      type: :object,
                      properties: {
                        startAt: {type: :string, example: "20/07/2021", description: "Date of start of good deal"},
                        endAt: {type: :string, example: "27/07/2021", description: "Date of end of good deal"},
                        discount: {type: :integer, example: 45, description: "Amount of discount (in %)"}
                      },
                      required: %w[startAt, endAt, discount]
                    },
                    characteristics: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          name: {type: :string, example: 'color', description: 'Name of characteristic'},
                          value: {type: :string, example: 'Bleu', description: 'Value of characteristic'}
                        },
                        required: %w[name, value]
                      }
                    }
                  },
                  required: %w[basePrice, weight, quantity, isDefault]
                }
              },
              origin: {type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)'},
              allergens: {type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)'},
              composition: {type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)'}
            },
            required: %w[id, name, description, brand, status, sellerAdvice, isService, categoryId, variants, characteristics]
          }
        end
      end
    end
  end
end
