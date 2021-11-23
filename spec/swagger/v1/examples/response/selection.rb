module V1
  module Examples
    module Response
      class Selection
        def self.to_h
          {
            type: 'object',
            properties: {
              name: { type: :string, example: "voiture", description: 'Selection name.' },
              slug: { type: :string, example: 'voiture-1', description: 'Selection slug.' },
              description: { type: :string, example: "Selection de voitures.", description: 'Description of the selection.' },
              tagIds: {
                type: :array,
                items: { type: :integer, example: "12", description: 'Tag id.' }
              },
              startAt: { type: :string, example: "20/07/2021", description: "Date of start of selection." },
              endAt: { type: :string, example: "27/07/2021", description: "Date of end of selection." },
              homePage: { type: :boolean, example: false, description: 'Show the selection at home.' },
              event: { type: :boolean, example: false, description: 'Selection is an event.' },
              state: {
                type: :string,
                enum: ["active", "inactive"]
              },
              imageUrl: { type: :string, example: "https:/mavillemonshopping-exemples.com/uploads/development/image/46718/file/thumb-473860fqsfsqfac939fb02d2a0263cf171.jpg" }
            }
          }
        end
      end
    end
  end
end
