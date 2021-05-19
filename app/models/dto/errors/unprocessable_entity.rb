module Dto
  module Errors
    class UnprocessableEntity < Dto::Error

      def initialize(detail = '')
        super(status: 422, message: 'Unprocessable Entity', detail: detail)
      end

    end
  end
end