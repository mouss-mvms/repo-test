module Dto
  module V1
    module Tag
      class Response
        attr_accessor :id, :name, :status, :featured, :image_url

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @status = args[:status]
          @featured = args[:featured]
          @image_url = args[:image_url]
        end

        def self.create(tag)
          new(
            id: tag.id,
            name: tag.name,
            status: tag.status,
            featured: tag.featured,
            image_url: tag.image_url
          )
        end

        def to_h
          {
            id: @id,
            name: @name,
            status: @status,
            featured: @featured,
            imageUrl: @image_url
          }
        end
      end
    end
  end
end