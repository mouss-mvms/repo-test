module V1
  module Examples
    module Response
      class Tag
        def self.to_h
          {
            type: :object,
            properties: {
              id: { type: :integer, example: 1, description: 'Unique identifier of a tag.'},
              name: { type: :string, example: 'Noël', description: 'Name of the Tag.' },
              status: { type: :string, example: 'active', enum: ['active', 'not_active'], description: 'Status of the Tag.' },
              featured: { type: :boolean, example: true },
              imageUrl: { type: :string, example: 'https://path/to/image.jpeg', description: 'Image url of the Tag.' }
            }
          }
        end
      end
    end
  end
end
