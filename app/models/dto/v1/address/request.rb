module Dto
  module V1
    module Address
      class Request
        attr_accessor :street_number, :route, :locality, :country, :postal_code, :latitude, :longitude, :addressable_type, :addressable_id, :insee_code

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
          @insee_code = args[:insee_code]
        end

      end
    end
  end
end
