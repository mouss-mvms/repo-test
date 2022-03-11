module Dao
  class Product
    def self.create(dto_product_request)
      ActiveRecord::Base.transaction do
        product = ::Product.create!(
          name: dto_product_request.name,
          shop_id: dto_product_request.shop_id,
          category_id: dto_product_request.category_id,
          brand_id: ::Brand.where(name: dto_product_request.brand).first_or_create.id,
          is_a_service: dto_product_request.is_service,
          pro_advice: dto_product_request.seller_advice,
          origin: dto_product_request.origin,
          allergens: dto_product_request.allergens,
          composition: dto_product_request.composition,
          fields_attributes: [
            { lang: "fr", field: "description", content: dto_product_request.description },
            { lang: "en", field: "description", content: "" }
          ]
        )

        if dto_product_request.citizen_id.present?
          citizen = Citizen.find(dto_product_request.citizen_id)
          citizen.products << product
          citizen.save
          if dto_product_request.citizen_advice
            ::Advice.create!(
              content: dto_product_request.citizen_advice,
              product_id: product.id,
              citizen_id: dto_product_request.citizen_id
            )
          end
        end

        if dto_product_request.provider
          api_provider = ApiProvider.where(name: dto_product_request.provider[:name]).first
          if api_provider
            product.api_provider_product = ApiProviderProduct.create!(api_provider: api_provider,
                                                                      external_product_id: dto_product_request.provider[:external_product_id])
          end
        end

        dto_product_request.variants.each do |variant_params|
          variant_params.product_id = product.id
          Dao::Variant.create(dto_variant_request: variant_params)
        end

        case dto_product_request.status
        when "submitted"
          product.status = :submitted
        when "offline"
          product.status = :offline
        else
          ::Products::StatusSpecifications::CanBeOnline.new.is_satisfied_by?(product) ?
            product.status = :online :
            product.status = :offline
        end

        product.save!

        return product
      end
    end

    def self.create_async(dto_product_request)
      CreateProductJob.perform_async(JSON.dump(dto_product_request))
    end

    def self.update(dto_product_request:)
      product = ::Product.find(dto_product_request.id)
      product.name = dto_product_request.name if dto_product_request.name.present?
      product.category_id = dto_product_request.category_id if dto_product_request.category_id.present?
      product.brand_id = ::Brand.where(name: dto_product_request.brand).first_or_create.id if dto_product_request.brand.present?
      product.is_a_service = dto_product_request.is_service unless dto_product_request.is_service.nil?
      product.origin = dto_product_request.origin if dto_product_request.origin.present?
      product.pro_advice = dto_product_request.seller_advice if dto_product_request.seller_advice.present?
      product.allergens = dto_product_request.allergens if dto_product_request.allergens.present?
      product.composition = dto_product_request.composition if dto_product_request.composition.present?
      set_description(product, dto_product_request.description) if dto_product_request.description.present?

      if dto_product_request.provider
        api_provider = ApiProvider.where(name: dto_product_request.provider[:name]).first
        if api_provider
          product.api_provider_product = ApiProviderProduct.create!(api_provider: api_provider,
                                                                    external_product_id: dto_product_request.provider[:external_product_id])
          product.save!
        end
      end

      product.advice.content = dto_product_request.citizen_advice if dto_product_request.citizen_advice && product.advice

      update_or_create_variant(variant_dtos: dto_product_request.variants, product: product) if dto_product_request.variants.present?

      case dto_product_request.status
      when "submitted"
        product.status = :submitted
      when "refused"
        product.status = :refused if product.submitted?
      when "offline"
        product.status = :offline
      else
        if product.submitted? && (dto_product_request.status == 'online' || dto_product_request.status == 'offline')
          product.status = dto_product_request.status
        end
        product.status = :online if ::Products::StatusSpecifications::CanBeOnline.new.is_satisfied_by?(product)
        product.status = :offline if ::Products::StatusSpecifications::CanBeOffline.new.is_satisfied_by?(product)
      end
      product.save!
      product.touch(:updated_at)

      product
    end

    private

    def self.update_or_create_variant(variant_dtos:, product:)
      variant_dtos.each do |variant_dto|
        variant_dto.product_id = product.id
        if variant_dto.id.present?
          product.references.find(variant_dto.id)
          Dao::Variant.update(dto_variant_request: variant_dto)
        else
          Dao::Variant.create(dto_variant_request: variant_dto)
        end
      end
    end

    def self.set_description(product, description)
      product.descriptions.destroy_all
      product.fields_attributes = [
        { lang: "fr", field: "description", content: description },
        { lang: "en", field: "description", content: "" }
      ]
    end

    def self.set_image(object:, image_url:)
      image = Shrine.remote_url(image_url)
      object.images.create!(file: image, position: 1)
    end

    def self.date_from_string(date_string:)
      return nil unless date_string

      date_array = date_string.split('/').map(&:to_i).reverse
      DateTime.new(date_array[0], date_array[1], date_array[2])
    end
  end
end

