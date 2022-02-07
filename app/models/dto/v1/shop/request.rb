module Dto
  module V1
    module Shop
      class Request
        attr_accessor :name,
          :avatar_id,
          :avatar_url,
          :cover_id,
          :cover_url,
          :image_ids,
          :image_urls,
          :description,
          :baseline,
          :schedules,
          :facebook_link,
          :instagram_link,
          :website_link,
          :address_request,
          :email,
          :siret,
          :mobile_number

        def initialize(**args)
          @name = args[:name]
          @avatar_id = args[:avatar_id]
          @avatar_url = args[:avatar_url]
          @cover_id = args[:cover_id]
          @cover_url = args[:cover_url]
          @image_ids = []
          args[:image_ids]&.each do |img_id|
            @image_ids << img_id
          end
          @image_urls = []
          args[:image_urls]&.each do |img_url|
            @image_urls << img_url
          end
          @description = args[:description]
          @baseline = args[:baseline]
          @email = args[:email]
          @mobile_number = args[:mobile_number]
          @facebook_link = args[:facebook_link]
          @instagram_link = args[:instagram_link]
          @website_link = args[:website_link]
          @address_request = Dto::V1::Address::Request.new(args[:address])
          @siret = args[:siret]
          @avatar_image_id = args[:avatar_image_id]
        end
      end
    end
  end
end
