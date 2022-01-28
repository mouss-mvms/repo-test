module Dao
  class Variant
    def self.create(dto_variant_request:)
      product = ::Product.find(dto_variant_request.product_id)
      sample = ::Sample.create!(name: product.name, default: dto_variant_request.is_default, product_id: product.id)

      if dto_variant_request.image_ids.present?
        images = Image.where(id: dto_variant_request.image_ids)
        sample.images << images
      elsif dto_variant_request.image_urls.present?
        dto_variant_request.image_urls.each do |image_url|
          Dao::Product.set_image(object: sample, image_url: image_url)
        end
      end

      characteristics = dto_variant_request.characteristics

      color_characteristic = characteristics.detect { |char| char.name == "color" }
      size_characteristic = characteristics.detect { |char| char.name == "size" }

      reference = ::Reference.create!(
        weight: dto_variant_request.weight,
        quantity: dto_variant_request.quantity,
        base_price: dto_variant_request.base_price,
        product_id: product.id,
        sample_id: sample.id,
        shop_id: product.shop.id,
        color_id: color_characteristic ? ::Color.where(name: color_characteristic.value).first_or_create.id : nil,
        size_id: size_characteristic ? ::Size.where(name: size_characteristic.value).first_or_create.id : nil
      )

      if dto_variant_request.provider
        api_provider = ApiProvider.where(name: dto_variant_request.provider[:name]).first
        if api_provider
          reference.api_provider_variant = ApiProviderVariant.create!(api_provider: api_provider,
                                                                    external_variant_id: dto_variant_request.provider[:external_variant_id])
          reference.save!

        end
      end

      good_deal_params = dto_variant_request.good_deal

      if good_deal_params && good_deal_params&.discount && good_deal_params&.end_at && good_deal_params&.start_at
        reference.good_deal = ::GoodDeal.new
        reference.good_deal.starts_at = date_from_string(date_string: good_deal_params.start_at)
        reference.good_deal.ends_at = date_from_string(date_string: good_deal_params.end_at)
        reference.good_deal.discount = good_deal_params.discount
        reference.good_deal.kind = "percentage"
        reference.good_deal.save!
      end

      return reference
    end

    def self.update(dto_variant_request:)
      @reference = Reference.find(dto_variant_request.id)
      if dto_variant_request.files
        dto_variant_request.files.each do |file|
          raise ApplicationController::UnpermittedParameter.new("Incorrect file format") unless file.is_a?(ActionDispatch::Http::UploadedFile)
          image_dto = Dto::V1::Image::Request.create(image: file)
          image = ::Image.create!(file: image_dto.tempfile)
          @reference.sample.images << image
        end
      end

      if dto_variant_request.image_ids.present?
        images = Image.where(id: dto_variant_request.image_ids)
        @reference.sample.images << images
      elsif dto_variant_request.image_urls.present?
        dto_variant_request.image_urls.each do |image_url|
          Dao::Product.set_image(object: @reference.sample, image_url: image_url)
        end
      end

      if dto_variant_request.provider
        if @reference.product.api_provider_product
          api_provider = ApiProvider.find_by(name: dto_variant_request.provider[:name])
          if api_provider
            if @reference.api_provider_variant
              @reference.api_provider_variant.api_provider = api_provider
              @reference.api_provider_variant.external_variant_id = dto_variant_request.provider[:external_variant_id]
            else
              @reference.api_provider_variant = ApiProviderVariant.create!(api_provider: api_provider,
                                                                           external_variant_id: dto_variant_request.provider[:external_variant_id])
            end
          end
          @reference.save!
        end
      end

      @reference.base_price = dto_variant_request.base_price if dto_variant_request.base_price
      @reference.weight = dto_variant_request.weight if dto_variant_request.weight
      @reference.quantity = dto_variant_request.quantity if dto_variant_request.quantity
      @reference.sample.default = dto_variant_request.is_default unless dto_variant_request.is_default.nil?
      if dto_variant_request.good_deal
        if @reference.good_deal
          @reference.good_deal.update(starts_at: dto_variant_request.good_deal&.start_at, ends_at: dto_variant_request.good_deal&.end_at, discount: dto_variant_request.good_deal&.discount)
        else
          GoodDeal.create!(starts_at: dto_variant_request.good_deal&.start_at, ends_at: dto_variant_request.good_deal&.end_at, discount: dto_variant_request.good_deal&.discount, reference: @reference)
        end
      end
      update_characteristics(dto_variant_request: dto_variant_request) if dto_variant_request.characteristics
      @reference.save!
      update_product_status
      @reference
    end

    private

    def self.set_image(object:, image_url:)
      begin
        image = Shrine.remote_url(image_url)
        object.images.create(file: image, position: 1)
      rescue StandardError => e
        Rails.logger.error(e)
        Rails.logger.error(e.message)
      end
    end

    def self.date_from_string(date_string:)
      return nil unless date_string

      date_array = date_string.split('/').map(&:to_i).reverse
      DateTime.new(date_array[0], date_array[1], date_array[2])
    end

    def self.update_characteristics(dto_variant_request:)
      return unless dto_variant_request.characteristics
      color_characteristic = dto_variant_request.characteristics.detect { |char| char.name == "color" }
      size_characteristic = dto_variant_request.characteristics.detect { |char| char.name == "size" }

      @reference.color_id = color_characteristic ? ::Color.where(name: color_characteristic.value).first_or_create.id : nil
      @reference.size_id = size_characteristic ? ::Size.where(name: size_characteristic.value).first_or_create.id : nil
      @reference
    end

    def self.update_product_status
      product = @reference.product
      product.status = :online if ::Products::StatusSpecifications::CanBeOnline.new.is_satisfied_by?(product)
      product.status = :offline if ::Products::StatusSpecifications::CanBeOffline.new.is_satisfied_by?(product)
      product.save!
    end
  end
end

