module Dto
  module V1
    module Shop
      class Response
        attr_accessor :id, :name, :slug, :image_urls, :cover_image_url, :avatar_image_url, :description, :baseline, :facebook_link, :instagram_link, :website_link, :address, :siret, :email, :mobile_number, :lowest_product_price, :highest_product_price

        def initialize(**args)
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @image_urls = []
          args[:image_urls]&.each do |img_url|
            @image_urls << img_url
          end
          @avatar_image_url = args[:avatar_image_url]
          @cover_image_url = args[:cover_image_url]
          @description = args[:description]
          @baseline = args[:baseline]
          @facebook_link = args[:facebook_link]
          @instagram_link = args[:instagram_link]
          @website_link = args[:website_link]
          @address = args[:address] || Dto::V1::Address::Response.new
          @siret = args[:siret]
          @email = args[:email]
          @mobile_number = args[:mobile_number]
          @lowest_product_price = args[:lowest_product_price]
          @highest_product_price = args[:highest_product_price]
        end

        def self.create(shop)
          image_urls = []
          shop.images.each do |shop_image|
            image_urls << shop_image.file.url
          end

          return Dto::V1::Shop::Response.new({
                                           id: shop.id,
                                           name: shop.name,
                                           slug: shop.slug,
                                           image_urls: image_urls,
                                           description: shop.french_description&.content,
                                           baseline: shop.french_baseline&.content,
                                           facebook_link: shop.facebook_url,
                                           instagram_link: shop.instagram_url,
                                           website_link: shop.url,
                                           address: Dto::V1::Address::Response.create(shop.address),
                                           siret: shop.siret,
                                           email: shop.email,
                                           mobile_number: shop.mobile_phone_number,
                                           avatar_image_url: shop.profil&.file_url(:thumb) || shop.profil&.file_url,
                                           cover_image_url: shop.featured&.file_url(:thumb) || shop.featured&.file_url,
                                           lowest_product_price: shop.cheapest_ref&.base_price,
                                           highest_product_price: shop.most_expensive_ref&.base_price
                                         })
        end

        def self.from_searchkick(shop)
          return Dto::V1::Shop::Response.new({
                                           id: shop['id'].to_i,
                                           name: shop['name'],
                                           slug: shop['slug'],
                                           image_urls: [shop['image_url']],
                                           description: shop['description'],
                                           baseline: shop['baseline']
                                         })
        end

        def to_h(fields = nil)
          hash = {}
          hash[:id] = @id if fields.nil? || (fields.any? && fields.include?('id'))
          hash[:name] = @name if fields.nil? || (fields.any? && fields.include?('name'))
          hash[:slug] = @slug if fields.nil? || (fields.any? && fields.include?('slug'))
          hash[:imageUrls] = @image_urls if fields.nil? || (fields.any? && fields.include?('imageUrls'))
          hash[:avatarImageUrl] = @avatar_image_url if fields.nil? || (fields.any? && fields.include?('avatarImageUrl'))
          hash[:coverImageUrl] = @cover_image_url if fields.nil? || (fields.any? && fields.include?('coverImageUrl'))
          hash[:baseline] = @baseline if fields.nil? || (fields.any? && fields.include?('baseline'))
          hash[:description] = @description if fields.nil? || (fields.any? && fields.include?('description'))
          hash[:facebookLink] = @facebook_link if fields.nil? || (fields.any? && fields.include?('facebookLink'))
          hash[:instagramLink] = @instagram_link if fields.nil? || (fields.any? && fields.include?('instagramLink'))
          hash[:websiteLink] = @website_link if fields.nil? || (fields.any? && fields.include?('websiteLink'))
          hash[:address] = @address.to_h if fields.nil? || (fields.any? && fields.include?('address'))
          hash[:siret] = @siret if fields.nil? || (fields.any? && fields.include?('siret'))
          hash[:email] = @email if fields.nil? || (fields.any? && fields.include?('email'))
          hash[:mobileNumber] = @mobile_number if fields.nil? || (fields.any? && fields.include?('mobile_number'))
          hash[:lowestProductPrice] = @lowest_product_price if fields.nil? || (fields.any? && fields.include?('lowestProductPrice'))
          hash[:highestProductPrice] = @highest_product_price if fields.nil? || (fields.any? && fields.include?('highestProductPrice'))
          hash
        end
      end
    end
  end
end
