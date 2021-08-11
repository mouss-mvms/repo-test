module Dto
  module Errors
    class InternalServer < Dto::Error

      def initialize(detail: "")
        super(status: 500, message: "Internal Server Error", detail: detail)
      end

    end
  end
end