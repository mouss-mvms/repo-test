module Dao
  module Shop

    def self.update(dto_shop_request:, shop:)
      shop.assign_attributes(
        name: dto_shop_request.name,
        email: dto_shop_request.email,
        mobile_phone_number: dto_shop_request.mobile_number,
        siret: dto_shop_request.siret,
        facebook_url: dto_shop_request.facebook_link,
        instagram_url: dto_shop_request.instagram_link,
        url: dto_shop_request.website_link,
      )

      set_images(dto: dto_shop_request, object: shop)
      set_description(dto_shop_request, shop) if dto_shop_request.description
      set_baseline(dto_shop_request, shop) if dto_shop_request.baseline

      dto_shop_request.address_request.addressable_id = shop.id
      Dto::V1::Address.build(dto_shop_request.address_request)

      shop.save!
      shop.touch(:updated_at)
      return shop
    end

    def self.create(dto_shop_request:)
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

      set_images(dto: dto_shop_request, object: shop)
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

    def self.set_images(dto:, object:)
      set_avatar_image(dto: dto, object: object)
      set_cover_image(dto: dto, object: object)
      set_shop_galleries(dto: dto, object: object)
    end

    def self.set_avatar_image(dto:, object:)
      if dto.avatar_id.present?
        object.profil_id = dto.avatar_id
      elsif dto.avatar_url.present?
        image = create_image(image_url: dto.avatar_url)
        object.update!(profil_id: image.id)
      end
    end

    def self.set_cover_image(dto:, object:)
      if dto.cover_id.present?
        object.featured_id = dto.cover_id
      elsif dto.cover_url.present?
        image = create_image(image_url: dto.cover_url)
        object.update!(featured_id: image.id)
      end
    end

    def self.set_shop_galleries(dto:, object:)
      if dto.image_ids.present?
        images = Image.where(id: dto.image_ids)
        images.each do |image|
          object.images.create!(file: image.file)
        end
      elsif dto.image_urls.present?
        dto.image_urls.map do |image_url|
          create_shop_gallery(shop: object, image_url: image_url)
        end
      end
    end

    def self.create_image(image_url:)
      begin
        file = Shrine.remote_url(image_url)
        image = Image.create(file: file, position: 1)
      rescue StandardError => e
        Rails.logger.error(e)
        Rails.logger.error(e.message)
      end
    end

    def self.create_shop_gallery(shop:, image_url:)
      begin
        file = Shrine.remote_url(image_url)
        shop.images.create!(file: file, position: 1)
      rescue StandardError => e
        Rails.logger.error(e)
        Rails.logger.error(e.message)
      end
    end
  end
end
