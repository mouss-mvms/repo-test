module Examples
  class Address
    def self.to_h
      {
        type: 'object',
        properties: {
          streetNumber: {
            type: 'string',
            example: "33",
            description: "Address's street number"
          },
          route: {
            type: 'string',
            example: "Rue Georges Bonnac",
            description: "Address's route"
          },
          locality: {
            type: 'string',
            example: "Bordeaux",
            description: "Address's locality"
          },
          country: {
            type: 'string',
            example: "France",
            description: "Address's country"
          },
          postalCode: {
            type: 'string',
            example: "33000",
            description: "Address's postal code"
          },
          latitude: {
            type: 'number',
            example: 44.82408,
            description: "Address's latitude"
          },
          longitude: {
            type: 'number',
            example: -0.62295,
            description: "Address's longitude"
          },
        }
      }
    end
  end
end
