module Dto
  module V1
    module Shop
      def self.build(dto_shop_request:, shop: nil)
        shop ? update(dto_shop_request, shop) : create(dto_shop_request)
      end

      private

      def self.update(dto_shop_request, shop)
        shop.update!(
          name: dto_shop_request.name,
          email: dto_shop_request.email,
          siret: dto_shop_request.siret,
          descriptions_attributes: [
            { lang: "fr", field: "description", content: dto_shop_request.description },
            { lang: "en", field: "description", content: "" }
          ],
          baselines_attributes: [
            { lang: "fr", field: "baseline", content: dto_shop_request.baseline },
            { lang: "en", field: "baseline", content: "" }
          ],
          facebook_url: dto_shop_request.facebook_link,
          instagram_url: dto_shop_request.instagram_link,
          url: dto_shop_request.website_link,
          )
        dto_shop_request.address_request.addressable_id = shop.id
        Dto::V1::Address.build(dto_shop_request.address_request)
        return shop
      end

      def self.create(dto_shop_request)
        shop = ::Shop.create!(
          name: dto_shop_request.name,
          email: dto_shop_request.email,
          siret: dto_shop_request.siret,
          descriptions_attributes: [
            { lang: "fr", field: "description", content: dto_shop_request.description },
            { lang: "en", field: "description", content: "" }
          ],
          baselines_attributes: [
            { lang: "fr", field: "baseline", content: dto_shop_request.baseline },
            { lang: "en", field: "baseline", content: "" }
          ],
          facebook_url: dto_shop_request.facebook_link,
          instagram_url: dto_shop_request.instagram_link,
          url: dto_shop_request.website_link,
          )
        dto_shop_request.address_request.addressable_id = shop.id
        Dto::V1::Address.build(dto_shop_request.address_request)
        shop.city_id = shop.address.city.id
        shop.save!
        return shop
      end
    end
  end
end
