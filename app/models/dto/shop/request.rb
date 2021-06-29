module Dto
  module Shop
    class Request
      attr_accessor :name, :image_urls, :description, :baseline, :schedules, :facebook_link, :instagram_link, :website_link, :address_request, :email, :siret

      def initialize(**args)
        @name = args[:name]
        @image_urls = []
        args[:image_urls]&.each do |img_url|
          @image_urls << img_url
        end
        @description = args[:description]
        @baseline = args[:baseline]
        @email = args[:email]
        @facebook_link = args[:facebook_link]
        @instagram_link = args[:instagram_link]
        @website_link = args[:website_link]
        @address_request = Dto::Address::Request.new(args[:address])
        @siret = args[:siret]
      end
    end
  end
end
