module Dto
  module Errors
    class Unauthorized < Dto::Error

      def initialize(detail = '')
        super(status: 401, message: 'Unauthorized', detail: detail)
      end

    end
  end
end
