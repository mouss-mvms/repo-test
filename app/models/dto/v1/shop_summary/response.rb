module Dto
  module V1
    module ShopSummary
      class Response
        attr_reader :_index, :_type, :_id, :_score, :id, :name, :created_at, :updated_at, :slug, :shop_url, :in_holidays, :category_tree_ids, :category_tree_names, :baseline, :description, :brands_name, :city_label, :city_slug, :insee_code, :territory_name, :territory_slug, :department_number, :deleted_at, :number_of_online_products, :number_of_orders, :image_url, :coupons, :pictogram_url, :services, :is_template, :score, :indexed_at

        def initialize(**args)
          @_index = args[:_index]
          @_type = args[:_type]
          @_id = args[:_id]
          @_score = args[:_score]
          @id = args[:id]
          @name = args[:name]
          @created_at = args[:created_at]
          @updated_at = args[:updated_at]
          @slug = args[:slug]
          @shop_url = args[:shop_url]
          @in_holidays = args[:in_holidays]
          @category_tree_ids = args[:category_tree_ids]
          @category_tree_names = args[:category_tree_names]
          @baseline = args[:baseline]
          @description = args[:description]
          @brands_name = args[:brands_name]
          @city_label = args[:city_label]
          @city_slug = args[:city_slug]
          @insee_code = args[:insee_code]
          @territory_name = args[:territory_name]
          @territory_slug = args[:territory_slug]
          @department_number = args[:department_number]
          @deleted_at = args[:deleted_at]
          @number_of_online_products = args[:number_of_online_products]
          @number_of_orders = args[:number_of_orders]
          @image_url = args[:image_url]
          @coupons = args[:coupons]
          @pictogram_url = args[:pictogram_url]
          @services = args[:services]
          @is_template = args[:is_template]
          @score = args[:score]
          @indexed_at = args[:indexed_at]
        end

        def self.create(shop_search_result)
          Dto::V1::ShopSummary::Response.new(shop_search_result)
        end

        def to_h
          {
            _index: _index,
            _type: _type,
            _id: _id,
            _score: _score,
            id: id,
            name: name,
            createdAt: created_at,
            updatedAt: updated_at,
            slug: slug,
            shopUrl: shop_url,
            inHolidays: in_holidays,
            categoryTreeIds: category_tree_ids,
            categoryTreeNames: category_tree_names,
            baseline: baseline,
            description: description,
            brandsName: brands_name,
            cityLabel: city_label,
            citySlug: city_slug,
            inseeCode: insee_code,
            territoryName: territory_name,
            territorySlug: territory_slug,
            departmentNumber: department_number,
            deletedAt: deleted_at,
            numberOfOnlineProducts: number_of_online_products,
            numberOfOrders: number_of_orders,
            imageUrl: image_url,
            coupons: coupons,
            pictogramUrl: pictogram_url,
            services: services,
            isTemplate: is_template,
            score: score,
            indexedAt: indexed_at
          }
        end
      end
    end
  end
end