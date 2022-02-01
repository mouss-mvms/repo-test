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
              imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg", description: "ImageUrl of a tag." }
            }
          }
        end
      end
    end
  end
end
