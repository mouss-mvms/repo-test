module Examples
  class GoodDeal
    def self.to_h
      {
        type: 'object',
        properties: {
          startAt: {
            type: 'string',
            format: 'date',
            example: '20/01/2021',
            description: 'Start date of a good deal.'
          },
          endAt: {
            type: 'string',
            format: 'date',
            example: '16/02/2021',
            description: 'End date of a good deal.'
          },
          discount: {
            type: 'integer',
            example: '20',
            minimum: 1,
            maximum: 100,
            description: 'Discount amount of a good deal.'
          }
        },
        required: %w[startAt endAt discount]
      }
    end
  end
end
