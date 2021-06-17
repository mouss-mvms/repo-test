module Dto
  module Category
    class Response
      attr_accessor :id, :name, :slug, :children

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
        @children = []
      end
    
      def self.create(product)
        return unless product.category
        Dto::Category::Response.new(
          id: product.category.id, 
          name: product.category.name,
          slug: product.category.slug
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