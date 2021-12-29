module Dto
  module V1
    module Address
      class Response
        attr_accessor :street_number, :route, :locality, :country, :postal_code, :latitude, :longitude, :insee_code

        def initialize(**args)
          @street_number = args[:street_number]
          @route = args[:route]
          @locality = args[:locality]
          @country = args[:country]
          @postal_code = args[:postal_code]
          @latitude = args[:latitude]
          @longitude = args[:longitude]
          @insee_code = args[:insee_code]
        end

        def self.create(address)
          return Dto::V1::Address::Response.new({
                                              street_number: address.street_number,
                                              route: address.route,
                                              locality: address.locality,
                                              country: address.country,
                                              postal_code: address.postal_code,
                                              latitude: address.latitude,
                                              longitude: address.longitude,
                                              insee_code: address.city&.insee_code
                                            })
        end

        def to_h
          {
            streetNumber: @street_number,
            route: @route,
            locality: @locality,
            country: @country,
            postalCode: @postal_code,
            latitude: @latitude,
            longitude: @longitude,
            inseeCode: @insee_code
          }
        end
      end
    end
  end
end
