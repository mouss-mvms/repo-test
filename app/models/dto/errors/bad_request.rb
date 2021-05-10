module Dto
  module Errors
    class BadRequest < Dto::Error
      
      def initialize(detail = "")
        super(status: 400, message: "Unprocessable Entity", detail: detail)
      end

    end
  end
end