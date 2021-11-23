module Dto
  module V1
    module Selection
      class Request
        attr_accessor :id, :name, :slug, :description, :image_url, :tag_ids, :start_at, :end_at, :home_page, :event, :state

        def initialize(**args)
          @id = args[:id]
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
      end
    end
  end
end