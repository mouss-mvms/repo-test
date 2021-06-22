module Dto
  module Shop
    class Response
      attr_accessor :id, :name, :slug, :image_urls, :description, :baseline, :facebook_link, :instagram_link, :website_link, :address, :siret, :email, :categories

      def initialize(**args)
        @id = args[:id]
        @name = args[:name]
        @slug = args[:slug]
        @image_urls = []
        args[:image_urls]&.each do |img_url|

        end
        @description = args[:description]
        @baseline = args[:baseline]
        @facebook_link = args[:facebook_link]
        @instagram_link = args[:instagram_link]
        @website_link = args[:website_link]
        @address = args[:address] || Dto::Address::Response.new
        @siret = args[:siret]
        @email = args[:email]
        @categories = []
        args[:categories]&.each do |category|
          @categories << category
        end
      end

      def self.create(shop)
        image_urls = []
        categories = []
        shop.images.each do |shop_image|
          image_urls << shop_image.file.url
        end
        shop.categories.each do |shop_category|
          categories << Dto::Category::Response.create(shop_category)
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
                                  website_url: shop.url,
                                  address: Dto::Address::Response.create(shop.address),
                                  siret: shop.siret,
                                  email: shop.email,
                                  categories: categories
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
          email: @email,
          categories: @categories,
        }
      end
    end
  end
end
