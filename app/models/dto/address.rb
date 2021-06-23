module Dto
  module Address
    def self.build(dto_address_request)
      address = ::Address.find_by(addressable_id: dto_address_request.addressable_id)
      address ?
        update(dto_address_request, address) :
        create(dto_address_request)
    end

    def self.update(dto_address_request, address)
      address.update!({
                        street_number: dto_address_request.street_number,
                        route: dto_address_request.route,
                        locality: dto_address_request.locality,
                        country: dto_address_request.country,
                        postal_code: dto_address_request.postal_code,
                        latitude: dto_address_request.latitude,
                        longitude: dto_address_request.longitude,
                        validate_firstname_lastname_phone: false,
                        addressable_id: dto_address_request.addressable_id,
                        addressable_type: dto_address_request.addressable_type
                      })
    end

    def self.create(dto_address_request)
      ::Address.create!({
                            street_number: dto_address_request.street_number,
                            route: dto_address_request.route,
                            locality: dto_address_request.locality,
                            country: dto_address_request.country,
                            postal_code: dto_address_request.postal_code,
                            latitude: dto_address_request.latitude,
                            longitude: dto_address_request.longitude,
                            validate_firstname_lastname_phone: false,
                            addressable_id: dto_address_request.addressable_id,
                            addressable_type: dto_address_request.addressable_type
                        })

    end
  end
end
