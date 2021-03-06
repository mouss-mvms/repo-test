module Dto
  module V1
    module Product
      def self.build(dto_product_request:, product: nil, citizen_id: nil)
        product = product.present? ?
                    update(dto_product_request: dto_product_request, product: product) :
                    create(dto_product_request: dto_product_request)

        if citizen_id.present?
          citizen = Citizen.find(citizen_id)
          citizen.products << product
          citizen.save
          if dto_product_request.citizen_advice
            ::Advice.create!(
              content: dto_product_request.citizen_advice,
              product_id: product.id,
              citizen_id: citizen_id
            )
          end
        end


        if dto_product_request.provider && product.api_provider_product.nil?
          provider = ApiProvider.where(name: dto_product_request.provider[:name]).first
          if provider
            product.api_provider_product = ApiProviderProduct.create(external_product_id: dto_product_request.provider[:external_product_id], api_provider: provider)
          end
        end

        dto_product_request.variants.each do |dto_variant|
          if dto_variant.id
            update_variant(dto_variant: dto_variant, dto_product_request: dto_product_request, product: product)
          else
            create_variant(dto_variant: dto_variant, dto_product_request: dto_product_request, product: product)
          end
        end
        return product
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

      def self.create(dto_product_request:)
        ::Product.create!(
          name: dto_product_request.name,
          shop_id: dto_product_request.shop_id,
          category_id: dto_product_request.category_id,
          brand_id: ::Brand.where(name: dto_product_request.brand).first_or_create.id,
          is_a_service: dto_product_request.is_service,
          status: dto_product_request.status || 'offline',
          pro_advice: dto_product_request.seller_advice,
          fields_attributes: [
            { lang: "fr", field: "description", content: dto_product_request.description },
            { lang: "en", field: "description", content: "" }
          ],
          api_provider_products: ApiProviderProduct.new(external_variant_id: dto_product_request.provider.external_variant_id)
        )
      end

      def self.update(dto_product_request:, product:)
        product.update!(
          name: dto_product_request.name,
          category_id: dto_product_request.category_id,
          brand_id: ::Brand.where(name: dto_product_request.brand).first_or_create.id,
          is_a_service: dto_product_request.is_service,
          status: dto_product_request.status || 'offline',
          pro_advice: dto_product_request.seller_advice,
          fields_attributes: [
            { lang: "fr", field: "description", content: dto_product_request.description },
            { lang: "en", field: "description", content: "" }
          ]
        )

        variant_ids_to_update = dto_product_request.variants.map(&:id)
        ::Reference.where(product_id: product.id).where.not(id: variant_ids_to_update).each do |ref_to_delete|
          ref_to_delete.api_provider_variant&.destroy!
          ref_to_delete.destroy!
        end
        ::Image.where(product_id: product.id).destroy_all
        ::Advice.where(product_id: product.id).destroy_all
        product.api_provider_product&.destroy!

        product
      end

      def self.date_from_string(date_string:)
        return nil unless date_string

        date_array = date_string.split('/').map(&:to_i).reverse
        DateTime.new(date_array[0], date_array[1], date_array[2])
      end

      private

      def self.create_variant(dto_variant:, dto_product_request:, product:)
        sample = ::Sample.create!(name: dto_product_request.name, default: dto_variant.is_default, product_id: product.id)

        if dto_variant.image_urls.present?
          dto_variant.image_urls.each do |image_url|
            Dto::V1::Product.set_image(object: sample, image_url: image_url)
          end
        end

        color_characteristic = dto_variant.characteristics.detect { |char| char.name == "color" }
        size_characteristic = dto_variant.characteristics.detect { |char| char.name == "size" }

        reference = ::Reference.create!(
          weight: dto_variant.weight,
          quantity: dto_variant.quantity,
          base_price: dto_variant.base_price,
          product_id: product.id,
          sample_id: sample.id,
          shop_id: product.shop.id,
          color_id: color_characteristic ? ::Color.where(name: color_characteristic.value).first_or_create.id : nil,
          size_id: size_characteristic ? ::Size.where(name: size_characteristic.value).first_or_create.id : nil,
        )

        if dto_variant.external_variant_id && reference.api_provider_variant.nil?
          reference.api_provider_variant = ApiProviderVariant.create!(external_variant_id: dto_variant.external_variant_id, api_provider: product.api_provider_product.api_provider)
        end

        dto_good_deal = dto_variant.good_deal if dto_variant.good_deal&.discount && dto_variant.good_deal&.end_at && dto_variant.good_deal&.start_at

        if dto_good_deal.present?
          reference.good_deal = ::GoodDeal.new
          reference.good_deal.starts_at = date_from_string(date_string: dto_good_deal.start_at)
          reference.good_deal.ends_at = date_from_string(date_string: dto_good_deal.end_at)
          reference.good_deal.discount = dto_good_deal.discount
          reference.good_deal.kind = "percentage"
        end
        reference.save!
        reference
      end

      def self.update_variant(dto_variant:, dto_product_request:, product:)
        reference = product.references.find(dto_variant.id)
        sample = reference.sample
        sample.update!(name: dto_product_request.name, default: dto_variant.is_default, product_id: product.id)

        if dto_variant.image_urls.present?
          sample.images.destroy_all
          dto_variant.image_urls.each do |image_url|
            Dto::V1::Product.set_image(object: sample, image_url: image_url)
          end
        end

        color_characteristic = dto_variant.characteristics.detect { |char| char.name == "color" }
        size_characteristic = dto_variant.characteristics.detect { |char| char.name == "size" }

        reference.update!(
          weight: dto_variant.weight,
          quantity: dto_variant.quantity,
          base_price: dto_variant.base_price,
          product_id: product.id,
          sample_id: sample.id,
          shop_id: product.shop.id,
          color_id: color_characteristic ? ::Color.where(name: color_characteristic.value).first_or_create.id : nil,
          size_id: size_characteristic ? ::Size.where(name: size_characteristic.value).first_or_create.id : nil,
        )

        if dto_variant.external_variant_id && reference.api_provider_variant.nil?
          reference.api_provider_variant = ApiProviderVariant.create!(external_variant_id: dto_variant.external_variant_id, api_provider: product.api_provider_product.api_provider)
        end

        dto_good_deal = dto_variant.good_deal if dto_variant.good_deal&.discount && dto_variant.good_deal&.end_at && dto_variant.good_deal&.start_at

        if dto_good_deal.present?
          if reference.good_deal
            reference.good_deal.update(starts_at: dto_variant.good_deal.start_at, ends_at: date_from_string(date_string: dto_good_deal.end_at), discount: dto_variant.good_deal.discount)
          else
            reference.good_deal = ::GoodDeal.new
            reference.good_deal.starts_at = date_from_string(date_string: dto_good_deal.start_at)
            reference.good_deal.ends_at = date_from_string(date_string: dto_good_deal.end_at)
            reference.good_deal.discount = dto_good_deal.discount
            reference.good_deal.kind = "percentage"
          end
        end
      end
    end
  end
end