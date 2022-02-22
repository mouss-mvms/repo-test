module V1
  module Examples
    module Response
      class Tag
        def self.to_h
          {
            type: :object,
            properties: {
              id: { type: :integer, example: 1, description: 'Unique identifier of a tag.' },
              name: { type: :string, example: 'Noël', description: 'Name of the Tag.' },
              status: { type: :string, example: 'active', enum: ['active', 'not_active'], description: 'Status of the Tag.' },
              featured: { type: :boolean, example: true },
              image: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 42 },
                  originalUrl: { type: :string, example: 'https://path/to/original-image.jpg' },
                  miniUrl: { type: :string, example: 'https://path/to/mini-format.jpg' },
                  thumbUrl: { type: :string, example: 'https://path/to/thumb-format.jpg' },
                  squareUrl: { type: :string, example: 'https://path/to/square-format.jpg' },
                  wideUrl: { type: :string, example: 'https://path/to/wide-format.jpg' }
                },
                description: "Image of a tag"
              },
            }
          }
        end
      end
    end
  end
end
