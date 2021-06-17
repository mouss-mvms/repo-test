module Dto
  module Shop
    class Response
      attr_accessor :id, :name, :slug

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
      end

      def self.create(shop)
        return Dto::Shop::Response.new({
                                  id: shop.id,
                                  name: shop.name,
                                  slug: shop.slug
                                })
      end

      def to_h
        {
          shop:
            {
              id: @id,
              name: @name,
              slug: @slug,
            }
        }
      end
    end
  end
end
