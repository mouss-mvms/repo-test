module V1
  module Examples
    class Review
      def self.to_h
        {
          type: :object,
          properties: {
            id: {
              type: "integer",
              example: 3,
              description: "Id of review"
            },
            content: {
              type: "string",
              example: "La boutique est super",
              description: "Content of review"
            },
            mark: {
              type: "integer",
              example: 3,
              description: "Mark of review"
            },
            shopId: {
              type: "integer",
              example: 57,
              description: "Shop id of review"
            },
            productId: {
              type: "integer",
              example: 57,
              description: "Product id of review"
            },
            userId: {
              type: "integer",
              example: 57,
              description: "User id author of review"
            },
            parentId: {
              type: "integer",
              example: 57,
              description: "Parent id review if current review is an answer to another review"
            },
            answers: {
              type: "array",
              items: {
                '$ref': '#/components/schemas/Review'
              },
              description: 'List of answers for the review.'
            },
          }
        }
      end
    end
  end
end