module Dto
  module Shop
    class Response
      attr_accessor :id, :name, :slug, :image_urls, :description, :baseline, :facebook_link, :instagram_link, :website_link, :address, :siret, :email

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
        @image_urls = []
        args[:image_urls]&.each do |img_url|
          @image_urls << img_url
        end
        @description = args[:description]
        @baseline = args[:baseline]
        @facebook_link = args[:facebook_link]
        @instagram_link = args[:instagram_link]
        @website_link = args[:website_link]
        @address = args[:address] || Dto::Address::Response.new
        @siret = args[:siret]
        @email = args[:email]
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
                                  image_urls: image_urls,
                                  description: shop.french_description&.content,
                                  baseline: shop.french_baseline&.content,
                                  facebook_link: shop.facebook_url,
                                  instagram_link: shop.instagram_url,
                                  website_link: shop.url,
                                  address: Dto::Address::Response.create(shop.address),
                                  siret: shop.siret,
                                  email: shop.email
                                })
      end

      def to_h
        {
          id: @id,
          name: @name,
          slug: @slug,
          imageUrls: @image_urls,
          baseline: @baseline,
          description: @description,
          schedules: @schedules,
          facebookLink: @facebook_link,
          instagramLink: @instagram_link,
          websiteLink: @website_link,
          address: @address.to_h,
          siret: @siret,
          email: @email
        }
      end
    end
  end
end
