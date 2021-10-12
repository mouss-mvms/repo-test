module Dao
  class Product
    def self.create(product_params)
      product_params = OpenStruct.new(product_params)
      product = ::Product.create!(
        name: product_params.name,
        shop_id: product_params.shop_id,
        category_id: product_params.category_id,
        brand_id: ::Brand.where(name: product_params.brand).first_or_create.id,
        is_a_service: product_params.is_service,
        status: product_params.status || 'offline',
        pro_advice: product_params.seller_advice,
        origin: product_params.origin,
        allergens: product_params.allergens,
        composition: product_params.composition,
        fields_attributes: [
          { lang: "fr", field: "description", content: product_params.description },
          { lang: "en", field: "description", content: "" }
        ]
      )

      if product_params.citizen_id.present?
        citizen = Citizen.find(product_params.citizen_id)
        citizen.products << product
        citizen.save
        if product_params.citizen_advice
          ::Advice.create!(
            content: product_params.citizen_advice,
            product_id: product.id,
            citizen_id: product_params.citizen_id
          )
        end
      end

      if product_params.image_urls.present?
        product_params.image_urls.each do |image_url|
          Dao::Product.set_image(object: product, image_url: image_url)
        end
      end

      if product_params.provider
        api_provider = ApiProvider.where(name: product_params.provider[:name]).first
        if api_provider
          product.api_provider_products << ApiProviderProduct.create!(api_provider: api_provider,
                                                                      external_product_id: product_params.provider[:external_product_id])
        end
        product.save!
      end

      product_params.variants.each do |variant_params|
        variant_params = OpenStruct.new(variant_params)
        sample = ::Sample.create!(name: product_params.name, default: variant_params.is_default, product_id: product.id)

        if variant_params.image_urls.present?
          variant_params.image_urls.each do |image_url|
            Dao::Product.set_image(object: sample, image_url: image_url)
          end
        end
        characteristics = variant_params.characteristics.map { |char| OpenStruct.new(char) }

        color_characteristic = characteristics.detect { |char| char.name == "color" }
        size_characteristic = characteristics.detect { |char| char.name == "size" }

        reference = ::Reference.create!(
          weight: variant_params.weight,
          quantity: variant_params.quantity,
          base_price: variant_params.base_price,
          product_id: product.id,
          sample_id: sample.id,
          shop_id: product.shop.id,
          color_id: color_characteristic ? ::Color.where(name: color_characteristic.name).first_or_create.id : nil,
          size_id: size_characteristic ? ::Size.where(name: size_characteristic.name).first_or_create.id : nil
        )

        good_deal_params = variant_params.good_deal ? OpenStruct.new(variant_params.good_deal) : nil

        if good_deal_params && good_deal_params&.discount && good_deal_params&.end_at && good_deal_params&.start_at
          reference.good_deal = ::GoodDeal.new
          reference.good_deal.starts_at = date_from_string(date_string: good_deal_params.start_at)
          reference.good_deal.ends_at = date_from_string(date_string: good_deal_params.end_at)
          reference.good_deal.discount = good_deal_params.discount
          reference.good_deal.kind = "percentage"
          reference.good_deal.save!
        end
      end
      return product
    end

    def self.create_async(product_params)
      CreateProductJob.perform_async(JSON.dump(product_params))
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

