module Dto
  module V1
    module ProductSummary
      class Response
        attr_reader :_index, :_type, :_id, :_score, :id, :name, :slug, :created_at, :updated_at, :description, :base_price, :good_deal_starts_at, :good_deal_ends_at, :price, :quantity, :category_id, :category_tree_names, :category_tree_ids, :status, :shop_name, :shop_id, :shop_slug, :in_holidays, :brand_name, :brand_id, :city_name, :city_label, :city_slug, :conurbation_slug, :insee_code, :territory_name, :territory_slug, :department_number, :product_citizen_nickname, :product_citizen_slug, :product_citizen_slug, :product_citizen_image_path, :default_sample_id, :shop_pictogram_url, :image_url, :product_page_url, :shop_url, :number_of_orders, :colors, :sizes, :selection_ids, :services, :shop_is_template, :score, :position, :indexed_at, :unique_reference_id, :is_a_service, :on_discount, :discount_price

        def initialize(**args)
          @_index = args[:_index]
          @_type = args[:_type]
          @_id = args[:_id]
          @_score = args[:_score]
          @id = args[:id]
          @name = args[:name]
          @slug = args[:slug]
          @created_at = args[:created_at]
          @updated_at = args[:updated_at]
          @description = args[:description]
          @base_price = args[:base_price]
          @good_deal_starts_at = args[:good_deal_starts_at]
          @good_deal_ends_at = args[:good_deal_ends_at]
          @price = args[:price]
          @quantity = args[:quantity]
          @category_id = args[:category_id]
          @category_tree_names = args[:category_tree_names]
          @category_tree_ids = args[:category_tree_ids]
          @status = args[:status]
          @shop_name = args[:shop_name]
          @shop_id = args[:shop_id]
          @shop_slug = args[:shop_slug]
          @in_holidays = args[:in_holidays]
          @brand_name = args[:brand_name]
          @brand_id = args[:brand_id]
          @city_name = args[:city_name]
          @city_label = args[:city_label]
          @city_slug = args[:city_slug]
          @conurbation_slug = args[:conurbation_slug]
          @insee_code = args[:insee_code]
          @territory_name = args[:territory_name]
          @territory_slug = args[:territory_slug]
          @department_number = args[:department_number]
          @product_citizen_nickname = args[:product_citizen_nickname]
          @product_citizen_slug = args[:product_citizen_slug]
          @product_citizen_slug = args[:product_citizen_slug]
          @product_citizen_image_path = args[:product_citizen_image_path]
          @default_sample_id = args[:default_sample_id]
          @shop_pictogram_url = args[:shop_pictogram_url]
          @image_url = args[:image_url]
          @product_page_url = args[:product_page_url]
          @shop_url = args[:shop_url]
          @number_of_orders = args[:number_of_orders]
          @colors = args[:colors]
          @sizes = args[:sizes]
          @selection_ids = args[:selection_ids]
          @services = args[:services]
          @shop_is_template = args[:shop_is_template]
          @score = args[:score]
          @position = args[:position]
          @indexed_at = args[:indexed_at]
          @unique_reference_id = args[:unique_reference_id]
          @is_a_service = args[:is_a_service]
          @on_discount = args[:on_discount]
          @discount_price = args[:discount_price]
        end

        def self.create(searchkick_product_response)
          discount_params = set_discount_price(searchkick_product_response)
          Dto::V1::ProductSummary::Response.new(searchkick_product_response.merge(discount_params))
        end

        def to_h
          {
            _index: @_index,
            _type: @_type,
            _id: @_id,
            _score: @_score,
            id: @id,
            name: @name,
            slug: @slug,
            createdAt: @created_at,
            updatedAt: @updated_at,
            description: @description,
            basePrice: @base_price,
            goodDealStartsAt: @good_deal_starts_at,
            goodDealEndsAt: @good_deal_ends_at,
            price: @price,
            quantity: @quantity,
            categoryId: @category_id,
            categoryTreeNames: @category_tree_names,
            categoryTreeIds: @category_tree_ids,
            status: @status,
            shopName: @shop_name,
            shopId: @shop_id,
            shopSlug: @shop_slug,
            inHolidays: @in_holidays,
            brandName: @brand_name,
            brandId: @brand_id,
            cityName: @city_name,
            cityLabel: @city_label,
            citySlug: @city_slug,
            conurbationSlug: @conurbation_slug,
            inseeCode: @insee_code,
            territoryName: @territory_name,
            territorySlug: @territory_slug,
            departmentNumber: @department_number,
            productCitizenNickname: @product_citizen_nickname,
            productCitizenSlug: @product_citizen_slug,
            productCitizenSlug: @product_citizen_slug,
            productcitizenImagePath: @product_citizen_image_path,
            defaultSampleId: @default_sample_id,
            shopPictogramUrl: @shop_pictogram_url,
            imageUrl: @image_url,
            productPageUrl: @product_page_url,
            shopUrl: @shop_url,
            numberOfOrders: @number_of_orders,
            colors: @colors,
            sizes: @sizes,
            selectionIds: @selection_ids,
            services: @services,
            shopIsTemplate: @shop_is_template,
            score: @score,
            position: @position,
            indexedAt: @indexed_at,
            uniqueReferenceId: @unique_reference_id,
            isAService: @is_a_service,
            onDiscount: @on_discount,
            discountPrice: @discount_price
          }
        end

        private

        def self.set_discount_price(searchkick_product_response)
          if  searchkick_product_response[:good_deal_starts_at] && searchkick_product_response[:good_deal_ends_at] && searchkick_product_response[:good_deal_starts_at] < Time.zone.now && searchkick_product_response[:good_deal_ends_at] > Time.zone.now
            cheapest_ref = ::Product.where(id: searchkick_product_response[:id])&.first&.cheapest_ref
            return { discount_price:  cheapest_ref.price, on_discount: true } if cheapest_ref&.has_an_active_good_deal?
          end
          { discount_price:  searchkick_product_response[:base_price], on_discount: false }
        end
      end
    end
  end
end