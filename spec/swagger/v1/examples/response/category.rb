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
              hasChildren: {
                type: 'boolean',
                example: 'true',
                description: 'Category has children.'
              },
              children: {
                type: 'array',
                items: {
                  '$ref': '#/components/schemas/Category'
                },
                description: 'List of children category.'
              }
            }
          }
        end
      end
    end
  end
end
