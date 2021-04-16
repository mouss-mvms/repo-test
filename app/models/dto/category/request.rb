module Dto
  module Category
    class Request
      attr_reader :id, :name

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
      end

      def self.create(**args)
        Dto::Category::Request.new(
          id: args[:id],
          name: args[:name]
        )
      end

    end
  end
end