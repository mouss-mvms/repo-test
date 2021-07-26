module Dto
  module Category
    class Response
      attr_accessor :id, :name, :slug, :children

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
        @children = args[:children]
      end

      def self.create(category)
        return nil if category.nil?

        Dto::Category::Response.new(
          id: category.id,
          name: category.name,
          slug: category.slug,
          children: category.children
        )
      end

      def to_h
        {
          id: @id,
          name: @name,
          slug: @slug,
          children: children
        }
      end
    end
  end
end