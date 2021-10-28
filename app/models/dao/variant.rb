module Dao
  class Variant
    def self.create(dto_variant_request:)
      product = ::Product.find(dto_variant_request.product_id)
      sample = ::Sample.create!(name: product.name, default: dto_variant_request.is_default, product_id: product.id)

      if dto_variant_request.image_urls.present?
        dto_variant_request.image_urls.each do |image_url|
          Dao::Variant.set_image(object: sample, image_url: image_url)
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

      if dto_variant_request.external_variant_id
        api_provider_product = product.api_provider_product
        if api_provider_product
          reference.api_provider_variant = ApiProviderVariant.create!(api_provider: api_provider_product.api_provider,
                                                                      external_variant_id: dto_variant_request.external_variant_id)
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

    def self.update(product, product_params)

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
  end
end

