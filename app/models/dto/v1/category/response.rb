module Dto
  module V1
    module Category
      class Response
        attr_accessor :id, :name, :slug, :children, :has_children, :type

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @has_children = args[:has_children]
          @children = args[:children]
          @type = args[:type]
        end

        def self.create(category)
          return nil if category.nil?
          children = category.children.to_a
          Dto::V1::Category::Response.new(
            id: category.id,
            name: category.name,
            has_children: children.present?,
            slug: category.slug,
            children: children.map { |child_category| self.create(child_category) },
            type: category.group
          )
        end

        def to_h(fields = nil)
          hash = {}
          hash[:id] = @id
          hash[:name] = @name
          hash[:slug] = @slug
          hash[:hasChildren] = @has_children
          hash[:children] = @children&.map { |child| child.to_h } if fields&.any? && fields.include?(:children)
          hash[:type] = @type if fields&.any? && fields.include?(:type)
          hash
        end
      end
    end
  end
end