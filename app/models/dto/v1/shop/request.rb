module Dto
  module V1
    module Shop
      class Request
        attr_accessor :name, :image_urls, :description, :baseline, :schedules, :facebook_link, :instagram_link, :website_link, :address_request, :email, :siret, :mobile_number, :avatar_image_id

        def initialize(**args)
          @name = args[:name]
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
