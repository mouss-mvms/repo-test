module Dto
  module V1
    module Selection
      class Request
        attr_accessor :id, :name, :slug, :description, :image_url, :image_id, :tag_ids, :start_at, :end_at, :home_page, :event, :state, :cover_id, :cover_url, :promoted, :long_description

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @description = args[:description]
          @image_url = args[:image_url]
          @image_id = args[:image_id]
          @tag_ids = []
          args[:tag_ids]&.each { |v| @tag_ids << v}
          @start_at = args[:start_at]
          @end_at = args[:end_at]
          @home_page = args[:home_page]
          @event = args[:event]
          @state = args[:state]
          @cover_url = args[:cover_url]
          @cover_id = args[:cover_id]
          @promoted = args[:promoted] || false
          @long_description = args[:long_description]
        end
      end
    end
  end
end