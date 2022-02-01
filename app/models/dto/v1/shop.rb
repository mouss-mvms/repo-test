module Dto
  module V1
    module Shop
      def self.build(dto_shop_request:, shop: nil)
        shop ? update(dto_shop_request, shop) : create(dto_shop_request)
      end

      private

      def self.update(dto_shop_request, shop)
        shop.assign_attributes(
          name: dto_shop_request.name,
          email: dto_shop_request.email,
          mobile_phone_number: dto_shop_request.mobile_number,
          siret: dto_shop_request.siret,
          facebook_url: dto_shop_request.facebook_link,
          instagram_url: dto_shop_request.instagram_link,
          url: dto_shop_request.website_link,
          profil_id: dto_shop_request.avatar_image_id
        )

        set_description(dto_shop_request, shop) if dto_shop_request.description
        set_baseline(dto_shop_request, shop) if dto_shop_request.baseline

        dto_shop_request.address_request.addressable_id = shop.id
        Dto::V1::Address.build(dto_shop_request.address_request)

        shop.save!
        shop.touch(:updated_at)
        return shop
      end

      def self.create(dto_shop_request)
        shop = ::Shop.create!(
          name: dto_shop_request.name,
          email: dto_shop_request.email,
          mobile_phone_number: dto_shop_request.mobile_number,
          siret: dto_shop_request.siret,
          facebook_url: dto_shop_request.facebook_link,
          instagram_url: dto_shop_request.instagram_link,
          url: dto_shop_request.website_link,
        )
        dto_shop_request.address_request.addressable_id = shop.id
        Dto::V1::Address.build(dto_shop_request.address_request)
        shop.city_id = shop.address.city.id

        set_description(dto_shop_request, shop) if dto_shop_request.description
        set_baseline(dto_shop_request, shop) if dto_shop_request.baseline

        shop.save!
        shop.touch(:updated_at)
        return shop
      end

      private

      def self.set_baseline(dto_shop_request, shop)
        shop.baselines
            .find_or_initialize_by(shop_id: shop.id, lang: 'fr')
            .update!(content: dto_shop_request.baseline)
      end

      def self.set_description(dto_shop_request, shop)
        shop.descriptions
            .find_or_initialize_by(shop_id: shop.id, lang: 'fr')
            .update!(content: dto_shop_request.description)
      end
    end
  end
end
