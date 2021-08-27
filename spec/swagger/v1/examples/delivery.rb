module V1
  module Examples
    class Delivery
      def self.to_h
        {
          type: 'object',
          properties: {
            id: {
              type: 'integer',
              example: 32,
              description: "Id of delivery service"
            },
            name: {
              type: 'string',
              example: "Delivery's name",
              description: "Name of delivery service"
            },
            slug: {
              type: 'string',
              example: "Delivery's slug",
              description: "Slug of delivery service"
            },
            description: {
              type: 'string',
              example: "Delivery's description",
              description: "Description of delivery service"
            },
            publicDescription: {
              type: 'string',
              example: "Delivery's public description",
              description: "Public description of delivery service"
            },
            publicDetailedDescription: {
              type: 'string',
              example: "Delivery's public detailed description",
              description: "Public detailed description of delivery service"
            },
            isExpress: {
              type: 'bool',
              example: true,
              description: "Is Delivery express"
            },
            isShopDependent: {
              type: 'bool',
              example: true,
              description: "Is Shop Dependent"
            },
            isDelivery: {
              type: 'bool',
              example: true,
              description: "Is Service is delivery"
            },
          }
        }
      end
    end
  end
end
