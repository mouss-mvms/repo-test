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

        dto_product_request.image_urls.each do |image_url|
          set_image(object: product, image_url: image_url)
        end

        dto_product_request.variants.each do |dto_variant|
          sample = ::Sample.create!(name: dto_product_request.name, default: dto_variant.is_default, product_id: product.id)

          if dto_variant.image_urls.present?
            dto_variant.image_urls.each do |image_url|
              set_image(object: sample, image_url: image_url)
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
            color_id: color_characteristic ? ::Color.where(name: color_characteristic.name).first_or_create.id : nil,
            size_id: size_characteristic ? ::Size.where(name: size_characteristic.name).first_or_create.id : nil
          )

          dto_good_deal = dto_variant.good_deal if dto_variant.good_deal&.discount && dto_variant.good_deal&.end_at && dto_variant.good_deal&.start_at

          if dto_good_deal.present?
            reference.good_deal = ::GoodDeal.new
            reference.good_deal.starts_at = date_from_string(date_string: dto_good_deal.start_at)
            reference.good_deal.ends_at = date_from_string(date_string: dto_good_deal.end_at)
            reference.good_deal.discount = dto_good_deal.discount
            reference.good_deal.kind = "percentage"
            reference.good_deal.save!
          end
        end
        return product
      end

      private

      def self.set_image(object:, image_url:)
        begin
          image = Shrine.remote_url(image_url)
          object.images.create(file: image)
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
          ]
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

        ::Reference.where(product_id: product.id).destroy_all
        ::Sample.where(product_id: product.id).destroy_all
        ::Image.where(product_id: product.id).destroy_all
        ::Advice.where(product_id: product.id).destroy_all

        product
      end

      def self.date_from_string(date_string:)
        return nil unless date_string

        date_array = date_string.split('/').map(&:to_i).reverse
        DateTime.new(date_array[0], date_array[1], date_array[2])
      end
    end
  end
end