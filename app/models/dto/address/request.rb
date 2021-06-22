module Dto
  module Address
    class Request
      attr_accessor :street_number, :route, :locality, :country, :postal_code, :latitude, :longitude, :addressable_type, :addressable_id

      def initialize(**args)
        @street_number = args[:street_number]
        @route = args[:route]
        @locality = args[:locality]
        @country = args[:country]
        @postal_code = args[:postal_code]
        @latitude = args[:latitude]
        @longitude = args[:longitude]
        @addressable_id = args[:addressable_id]
        @addressable_type = args[:addressable_type] || "Shop"
      end

      def build
        ::Address.create!({
                          street_number: street_number,
                          route: route,
                          locality: locality,
                          country: country,
                          postal_code: postal_code,
                          latitude: latitude,
                          longitude: longitude,
                          validate_firstname_lastname_phone: false,
                          addressable_id: addressable_id,
                          addressable_type: addressable_type
                        })
      end

    end
  end
end
