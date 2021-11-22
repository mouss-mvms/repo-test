module Dto
  module V1
    module Selection
      class Response
        attr_accessor :name, :slug, :description, :image_url, :tag_ids, :start_at, :end_at, :home_page, :event, :state

        def initialize(**args)
          @name = args[:name]
          @slug = args[:slug]
          @description = args[:description]
          @image_url = args[:image_url]
          @tag_ids = args[:tag_ids]
          @start_at = args[:start_at]
          @end_at = args[:end_at]
          @home_page = args[:home_page]
          @event = args[:event]
          @state = args[:state]
        end

        def self.create(selection)
          return Dto::V1::Selection::Response.new(
            {
              name: selection.name,
              slug: selection.slug,
              description: selection.description,
              image_url: selection&.image&.file_url,
              tag_ids: selection.tags,
              start_at: selection.begin_date,
              end_at: selection.end_date,
              home_page: selection.is_home,
              event: selection.is_event,
              state: selection.state
            }
          )
        end

        def to_h
          {
            name: @name,
            slug: @slug,
            description: @description,
            imageUrl: @image_url,
            tagIds: @tag_ids,
            startAt: @start_at,
            endAt: @end_at,
            homePage: @home_page,
            event: @event,
            state: @state
          }
        end
      end
    end
  end
end
