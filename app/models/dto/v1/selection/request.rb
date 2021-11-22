module Dto
  module V1
    module Selection
      class Request
        attr_accessor :name, :slug, :description, :image_url, :tag_ids, :start_at, :end_at, :show_at_home, :event, :state

        def initialize(**args)
          @name = args[:name]
          @slug = args[:slug]
          @description = args[:description]
          @image_url = args[:image_url]
          @tag_ids = args[:tag_ids]
          @start_at = args[:start_at]
          @end_at = args[:end_at]
          @show_at_home = args[:show_at_home]
          @event = args[:event]
          @state = args[:state]
        end
      end
    end
  end
end