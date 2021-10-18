module Dto
  module Errors
    class Conflict < Dto::Error

      def initialize(detail = '')
        super(status: 409, message: 'Conflict', detail: detail)
      end

    end
  end
end
