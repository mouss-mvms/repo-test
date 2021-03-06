module V1
  module Examples
    module Response
      class Product
        def self.to_h
          {
            type: :object,
            properties: {
              id: { type: :integer, example: 1, description: 'Unique identifier of a product' },
              name: { type: :string, example: "Air jordan", description: 'Name of product' },
              description: { type: :string, example: "Chaussures trop bien", description: 'Description of product' },
              brand: { type: :string, example: "Nike", description: 'Brand of product' },
              status: { type: :string, example: "online", description: 'Status of product', enum: ["online", "offline", "submitted", "draft_cityzen", "refused"] },
              shopId: { type: :integer, example: 1, description: 'Unique identifier product shop' },
              shopName: { type: :string, example: "Ma super boutique", description: 'Product shop name' },
              sellerAdvice: { type: :string, example: "Taille petite, prendre une demi pointure au dessus", description: 'Advice from seller of product' },
              isService: { type: :boolean, example: false, description: 'Tell if the product is a service' },
              citizenAdvice: { type: :string, example: 'Produit trouvé un commercant trop sympa', description: 'Advice from citizen of product' },
              category: {
                '$ref': '#/components/schemas/Category',
                description: 'Category of a product'
              },
              citizen: {
                '$ref': '#/components/schemas/Citizen',
                description: 'Information about citizen who shared the products'
              },
              variants: {
                type: :array,
                items: { '$ref': '#/components/schemas/Variant' }
              },
              origin: { type: :string, example: 'France', description: 'Origin of product. (This field is mandatory for some categories)' },
              allergens: { type: :string, example: 'Contient des traces de fruit à coques', description: 'Advice of potencial allergens. (This field is mandatory for some categories)' },
              composition: { type: :string, example: 'Oeuf, sucre', description: 'Composition of product. (This field is mandatory for some categories)' },
              provider: {
                type: :object,
                properties: {
                  name: { type: :string, example: 'wynd', description: 'Name of provider' },
                  externalProductId: { type: :string, example: '33ur', description: 'Id used by the provider' }
                },
                required: %w[name, externalProductId]
              },
              createdAt: { type: :string, description: 'DateTime of creation of product' },
              updatedAt: { type: :string, description: 'DateTime of last update of product' },
            },
          }
        end
      end
    end
  end
end
