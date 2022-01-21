module Dto
  module V1
    module Category
      class Response
        attr_accessor :id, :name, :slug, :children, :has_children

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @has_children = args[:has_children]
          @children = args[:children]
        end

        def self.create(category, with_children = "false")
          return nil if category.nil?
          children = category.children.to_a
          Dto::V1::Category::Response.new(
            id: category.id,
            name: category.name,
            has_children: children.present?,
            slug: category.slug,
            children: with_children == "true" ? children.map { |child_category| self.create(child_category, false) } : nil
          )
        end

        def to_h
          {
            id: @id,
            name: @name,
            slug: @slug,
            hasChildren: @has_children,
            children: @children&.map(&:to_h)
          }
        end
      end
    end
  end
end