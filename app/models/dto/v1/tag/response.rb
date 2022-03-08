module Dto
  module V1
    module Tag
      class Response
        attr_accessor :id, :name, :status, :featured, :image

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @status = args[:status]
          @featured = args[:featured]
          @image = args[:image]
        end

        def self.create(tag)
          new(
            id: tag.id,
            name: tag.name,
            status: tag.status,
            featured: tag.featured,
            image: Dto::V1::Image::Response.create(tag.image)
          )
        end

        def to_h
          {
            id: @id,
            name: @name,
            status: @status,
            featured: @featured,
            image: @image&.to_h
          }
        end
      end
    end
  end
end