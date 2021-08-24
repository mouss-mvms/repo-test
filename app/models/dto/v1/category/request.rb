module Dto
  module V1
    module Category
      class Request
        attr_reader :id, :name

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
        end

      end
    end
  end
end