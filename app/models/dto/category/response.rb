module Dto
  module Category
    class Response
      attr_reader :id, :name

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
      end
    
      def self.create(product)
        return unless product.category
        Dto::Category::Response.new(
          id: product.category.id, 
          name: product.category.name
        )
      end

      def to_h
        {
          id: @id,
          name: @name
        }
      end
    end
  end
end