module Dto
  module V1
    module CategorySummary
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

        def self.create(category, fields)
          return nil if category.nil?
          Dto::V1::CategorySummary::Response.new(
            id: category.id,
            name: category.name,
            has_children: category.has_children,
            slug: category.slug,
            children: fields[:children] ? get_children(category) : [],
            type: category.group
          )
        end

        def to_h(fields = nil)
          hash = {}
          hash[:id] = @id
          hash[:name] = @name
          hash[:slug] = @slug
          hash[:hasChildren] = @has_children
          hash[:type] = @type
          hash[:children] = @children&.map { |child| child.to_h } if fields&.any? && fields.include?(:children)
          hash
        end

        private

        def self.get_children(category)
          categories = ::Category.search("*", { where: { parent_id: category.id }, load: false })
          categories.map { |child_category| self.create(child_category, { children: false }) }
        end
      end
    end
  end
end