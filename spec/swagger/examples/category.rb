module Examples
  class Category
    def self.to_h
      {
        type: 'object',
        properties: {
          id: {
            type: 'integer',
            example: 1,
            description: 'Unique identifier of a category.'
          },
          name: {
            type: 'string',
            example: 'Mobilier extérieur',
            description: 'Display name of a category.'
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
