module V1
  module Examples
    module Response
      class Category
        def self.to_h
          {
            type: 'object',
            properties: {
              id: {
                type: 'integer',
                example: ENV['UNCLASSIFIED_CATEGORY_ID'],
                description: 'Unique identifier of a category.'
              },
              name: {
                type: 'string',
                example: 'Non classée',
                description: 'Display name of a category.'
              },
              slug: {
                type: 'string',
                example: 'non_classée',
                description: 'Display slug of a category.'
              },
              hasChildren: {
                type: 'boolean',
                example: 'true',
                description: 'Category has children.'
              },
              children: {
                type: 'array',
                items: {
                  type: 'object',
                  properties: {
                    id: {
                      type: 'integer',
                      example: ENV['UNCLASSIFIED_CATEGORY_ID'],
                      description: 'Unique identifier of a category.'
                    },
                    name: {
                      type: 'string',
                      example: 'Non classée',
                      description: 'Display name of a category.'
                    },
                    slug: {
                      type: 'string',
                      example: 'non_classée',
                      description: 'Display slug of a category.'
                    },
                    hasChildren: {
                      type: 'boolean',
                      example: 'true',
                      description: 'Category has children.'
                    },
                    type: {
                      type: 'string',
                      example: 'dry-food',
                      description: 'Types of category',
                      enum: ['dry-food', 'fresh-food', 'frozen-food', 'alcohol', 'explicit', 'cosmetic', 'clothing', 'food', 'services', 'unclassified']
                    }
                  }
                },
                description: 'List of children category.'
              },
              type: {
                type: 'string',
                example: 'dry-food',
                description: 'Types of category',
                enum: ['dry-food', 'fresh-food', 'frozen-food', 'alcohol', 'explicit', 'cosmetic', 'clothing', 'food', 'services', 'unclassified']
              }
            }
          }
        end
      end
    end
  end
end
