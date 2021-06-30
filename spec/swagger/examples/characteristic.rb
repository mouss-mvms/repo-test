module Examples
  class Characteristics
    def self.to_h
      {
        type: 'object',
        properties: {
          name: {
            type: 'string',
            example: 'color',
            enum: ['color', 'size'],
            description: 'Type of a characteristic.'
          },
          value: {
            type: 'string',
            example: 'blue',
            description: 'Display name of a characteristic.'
          }
        },
        required: %w[name type]
      }
    end
  end
end
