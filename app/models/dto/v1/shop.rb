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
          mobile_phone_number: dto_shop_request.mobile_number,
          siret: dto_shop_request.siret,
          facebook_url: dto_shop_request.facebook_link,
          instagram_url: dto_shop_request.instagram_link,
          url: dto_shop_request.website_link,
          profil_id: dto_shop_request.avatar_image_id
          )
        dto_shop_request.address_request.addressable_id = shop.id
        if dto_shop_request.description
          french_descriptions = I18nshop.where(shop_id: shop.id, field: 'description', lang: 'fr')
          if french_descriptions.any?
            french_description = french_descriptions.first
            french_description.content = dto_shop_request.description
            french_description.save!
          else
            I18nshop.create!(shop_id: shop.id, field: 'description', lang: 'fr', content: dto_shop_request.description)
          end
        end

        if dto_shop_request.baseline
          french_baselines = I18nshop.where(shop_id: shop.id, field: 'baseline', lang: 'fr')
          if french_baselines.any?
            french_baseline = french_baselines.first
            french_baseline.content = dto_shop_request.baseline
            french_baseline.save!
          else
            I18nshop.create!(shop_id: shop.id, field: 'baseline', lang: 'fr', content: dto_shop_request.baseline)
          end
        end

        Dto::V1::Address.build(dto_shop_request.address_request)
        return shop
      end

      def self.create(dto_shop_request)
        shop = ::Shop.create!(
          name: dto_shop_request.name,
          email: dto_shop_request.email,
          mobile_phone_number: dto_shop_request.mobile_number,
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
