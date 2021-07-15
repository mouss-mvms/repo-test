module Dto
  module Errors
    class Forbidden < Dto::Error

      def initialize(detail: '')
        super(status: 403, message: 'Forbidden', detail: detail)
      end

    end
  end
end
