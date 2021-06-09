module Dto
  module Product
    def self.build(dto_product:, dto_category:, shop_id:, product: nil)
      product = if product.present?
                  update_product(dto_product: dto_product, dto_category: dto_category, shop_id: shop_id, product: product)
                else
                  create_product(dto_product: dto_product, dto_category: dto_category, shop_id: shop_id)
                end

      dto_product.variants.each do |dto_variant|
        sample = ::Sample.create!(name: dto_product.name, default: dto_variant.is_default, product_id: product.id)

        if dto_variant.image_urls.present?
          dto_variant.image_urls.each do |image_url|
            set_image_on_sample(sample: sample, image_url: image_url)
          end
        end

        dto_good_deal = dto_variant.good_deal if dto_variant&.good_deal&.discount && dto_variant&.good_deal&.end_at && dto_variant&.good_deal&.start_at
        good_deal = nil

        if dto_good_deal && dto_good_deal.start_at && dto_good_deal.end_at
          good_deal = ::GoodDeal.create!(
            starts_at: date_from_string(date_string: dto_good_deal.start_at),
            ends_at: date_from_string(date_string: dto_good_deal.end_at),
            discount: dto_good_deal.discount,
            kind: "percentage"
          )
        end

        color_characteristic = dto_variant.characteristics.detect { |char| char.type == "color" }
        size_characteristic = dto_variant.characteristics.detect { |char| char.type == "size" }

        ::Reference.create!(
          weight: dto_variant.weight,
          quantity: dto_variant.quantity,
          base_price: dto_variant.base_price,
          product_id: product.id,
          sample_id: sample.id,
          shop_id: shop_id,
          good_deal_id: good_deal&.id,
          color_id: color_characteristic ? ::Color.where(name: color_characteristic.name).first_or_create.id : nil,
          size_id: size_characteristic ? ::Size.where(name: size_characteristic.name).first_or_create.id : nil
        )
      end

      return product
    end

    private

    def self.set_image_on_sample(sample:, image_url:)
      begin
        image = Shrine.remote_url(image_url)
        sample.images.create(file: image)
      rescue StandardError => e

      end
    end

    def self.create_product(dto_product:, dto_category:, shop_id:)
      ::Product.create!(
        name: dto_product.name,
        shop_id: shop_id,
        category_id: dto_category.id,
        brand_id: ::Brand.where(name: dto_product.brand).first_or_create.id,
        is_a_service: dto_product.is_service,
        status: dto_product.status || 'offline',
        pro_advice: dto_product.seller_advice,
        fields_attributes: [
          { lang: "fr", field: "description", content: dto_product.description },
          { lang: "en", field: "description", content: "" }
          ]
        )
    end

    def self.update_product(dto_product:, dto_category:, shop_id:, product:)
      product.update!(
        name: dto_product.name,
        category_id: dto_category.id,
        brand_id: ::Brand.where(name: dto_product.brand).first_or_create.id,
        is_a_service: dto_product.is_service,
        status: dto_product.status || 'offline',
        pro_advice: dto_product.seller_advice,
        fields_attributes: [
          { lang: "fr", field: "description", content: dto_product.description },
          { lang: "en", field: "description", content: "" }
        ]
      )

      ::Reference.where(product_id: product.id).destroy_all
      ::Sample.where(product_id: product.id).destroy_all

      product
    end

    def self.date_from_string(date_string:)
      return nil unless date_string

      date_array = date_string.split('/').map(&:to_i).reverse
      DateTime.new(date_array[0], date_array[1], date_array[2])
    end
  end
end