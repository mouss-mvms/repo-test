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

    end
  end
end
