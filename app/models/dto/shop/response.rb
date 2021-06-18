module Dto
  module Shop
    class Response
      attr_accessor :id, :name, :slug, :image_urls

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
        @image_urls = args[:image_urls] || []
      end

      def self.create(shop)
        image_urls = []
        shop.images.each do |shop_image|
          image_urls << shop_image.file.url
        end
        return Dto::Shop::Response.new({
                                  id: shop.id,
                                  name: shop.name,
                                  slug: shop.slug,
                                  image_urls: image_urls
                                })
      end

      def to_h
        {
          shop:
            {
              id: @id,
              name: @name,
              slug: @slug,
              image_urls: @image_urls
            }
        }
      end
    end
  end
end
