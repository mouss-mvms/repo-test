module Dto
  module Errors
    class NotFound < Dto::Error

      def initialize(detail = "")
        super(status: 404, message: "Not Found", detail: detail)
      end

    end
  end
end