module Dao
  module Shop

    def self.update(dto_shop_request:, shop:)
      shop.name = dto_shop_request.name unless dto_shop_request.name.blank?
      shop.email = dto_shop_request.email unless dto_shop_request.email.blank?
      shop.siret = dto_shop_request.siret unless dto_shop_request.siret.blank?
      shop.mobile_phone_number = dto_shop_request.mobile_number unless dto_shop_request.mobile_number.blank?
      shop.facebook_url = dto_shop_request.facebook_link unless dto_shop_request.facebook_link.blank?
      shop.instagram_url = dto_shop_request.instagram_link unless dto_shop_request.instagram_link.blank?
      shop.url = dto_shop_request.website_link unless dto_shop_request.website_link.blank?

      set_images(dto: dto_shop_request, object: shop)
      set_description(dto_shop_request, shop) if dto_shop_request.description
      set_baseline(dto_shop_request, shop) if dto_shop_request.baseline

      if dto_shop_request.address_request
        dto_shop_request.address_request.addressable_id = shop.id
        Dto::V1::Address.build(dto_shop_request.address_request)
      end

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

    def self.set_thumbnail(dto:, object:)
      if dto.thumbnail_url
        image = create_image(image_url: dto.thumbnail_url)
        object.update!(thumbnail_id: image.id)
      else
        if dto.thumbnail_id
          object.thumbnail_id = dto.thumbnail_id
        end
      end
    end

    def self.set_images(dto:, object:)
      set_avatar_image(dto: dto, object: object)
      set_cover_image(dto: dto, object: object)
      set_thumbnail(dto: dto, object: object)
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
