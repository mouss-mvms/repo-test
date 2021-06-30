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

      def self.create(category)
        Dto::Category::Response.new(
          id: category.id,
          name: category.name,
          slug: category.slug
        )
      end

      def to_h
        {
          id: @id,
          name: @name,
          slug: @slug
        }
      end
    end
  end
end