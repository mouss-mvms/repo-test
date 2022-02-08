module Dto
  module V1
    module Selection
      class Response
        attr_accessor :id, :name, :slug, :description, :image, :tag_ids, :start_at, :end_at, :home_page, :event, :state, :order, :products_count

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @description = args[:description]
          @image = args[:image]
          @tag_ids = args[:tag_ids]
          @start_at = args[:start_at]
          @end_at = args[:end_at]
          @home_page = args[:home_page]
          @event = args[:event]
          @state = args[:state]
          @order = args[:order]
          @products_count = args[:products_count]
        end

        def self.create(selection)
          return Dto::V1::Selection::Response.new(
            {
              id: selection.id,
              name: selection.name,
              slug: selection.slug,
              description: selection.description,
              image: Dto::V1::Image::Response.create(selection&.image),
              tag_ids: selection.tag_ids,
              start_at: selection.begin_date,
              end_at: selection.end_date,
              home_page: selection.is_home,
              event: selection.is_event,
              state: selection.state,
              order: selection.order,
              products_count: selection.products.count
            }
          )
        end

        def to_h
          {
            id: @id,
            name: @name,
            slug: @slug,
            description: @description,
            image: @image.to_h,
            tagIds: @tag_ids,
            startAt: @start_at&.strftime('%d/%m/%Y'),
            endAt: @end_at&.strftime('%d/%m/%Y'),
            homePage: @home_page,
            event: @event,
            state: @state,
            order: @order,
            productsCount: @products_count
          }
        end
      end
    end
  end
end
