module Examples
  module Errors
    class Error
      attr_reader :error

      def initialize(message_example:, status_example:, detail_example:)
        @error = {
          type: "object",
          properties: {
            detail: {
              type: "string",
              example: detail_example,
              description: "Message of an error."
            },
            message: {
              type: "string",
              example: message_example,
              description: "Display description error."
            },
            status: {
              type: "integer",
              example: status_example,
              description: "Status of an error."
            }
          }
        }
      end
    end

    class InternalError < Error
      def initialize
        super(message_example: "Internal Error", status_example: 500, detail_example: '')
      end
    end

    class Unauthorized < Error
      def initialize
        super(message_example: "Unauthorized", status_example: 401, detail_example: "")
      end
    end

    class Forbidden < Error
      def initialize
        super(message_example: "Forbidden", status_example: 403, detail_example: "")
      end
    end

    class BadRequest < Error
      def initialize
        super(message_example: "Bad Request", status_example: 400, detail_example: "The syntax of the query is incorrect.")
      end
    end

    class UnprocessableEntity < Error
      def initialize
        super(message_example: "Unprocessable Entity", status_example: 422, detail_example: "Password or email invalid.")
      end
    end

    class NotFound < Error
      def initialize
        super(message_example: "Not found", status_example: 404, detail_example: "Resource not found")
      end
    end
  end
end
