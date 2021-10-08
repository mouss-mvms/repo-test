module V1
  module Examples
    module Response
      class Brand
        def self.to_h
          {
            type: :object,
            properties: {
              id: {
                type: 'integer',
                example: 1,
                description: 'Unique identifier of a brand.'
              },
              name: {
                type: 'string',
                example: 'Rebok',
                description: 'Display name of a brand.'
              }
            }
          }
        end
      end
    end
  end
end