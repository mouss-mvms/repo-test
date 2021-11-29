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

        def to_h(fields = nil)
          hash = {}
          hash[:_index] = _index if fields.nil? || (fields.any? && fields.include?("_index"))
          hash[:_type] = _type if fields.nil? || (fields.any? && fields.include?("_type"))
          hash[:_id] = _id.to_i if fields.nil? || (fields.any? && fields.include?("_id"))
          hash[:_score] = _score if fields.nil? || (fields.any? && fields.include?("_score"))
          hash[:id] = id.to_i if fields.nil? || (fields.any? && fields.include?("id"))
          hash[:name] = name if fields.nil? || (fields.any? && fields.include?("name"))
          hash[:createdAt] = created_at if fields.nil? || (fields.any? && fields.include?("createdAt"))
          hash[:updatedAt] = updated_at if fields.nil? || (fields.any? && fields.include?("updatedAt"))
          hash[:slug] = slug if fields.nil? || (fields.any? && fields.include?("slug"))
          hash[:shopUrl] = shop_url if fields.nil? || (fields.any? && fields.include?("shopUrl"))
          hash[:inHolidays] = in_holidays if fields.nil? || (fields.any? && fields.include?("inHolidays"))
          hash[:categoryTreeIds] = category_tree_ids if fields.nil? || (fields.any? && fields.include?("categoryTreeIds"))
          hash[:categoryTreeNames] = category_tree_names if fields.nil? || (fields.any? && fields.include?("categoryTreeNames"))
          hash[:baseline] = baseline if fields.nil? || (fields.any? && fields.include?("baseline"))
          hash[:description] = description if fields.nil? || (fields.any? && fields.include?("description"))
          hash[:brandsName] = brands_name if fields.nil? || (fields.any? && fields.include?("brandsName"))
          hash[:cityLabel] = city_label if fields.nil? || (fields.any? && fields.include?("cityLabel"))
          hash[:citySlug] = city_slug if fields.nil? || (fields.any? && fields.include?("citySlug"))
          hash[:inseeCode] = insee_code if fields.nil? || (fields.any? && fields.include?("inseeCode"))
          hash[:territoryName] = territory_name if fields.nil? || (fields.any? && fields.include?("territoryName"))
          hash[:territorySlug] = territory_slug if fields.nil? || (fields.any? && fields.include?("territorySlug"))
          hash[:departmentNumber] = department_number if fields.nil? || (fields.any? && fields.include?("departmentNumber"))
          hash[:deletedAt] = deleted_at if fields.nil? || (fields.any? && fields.include?("deletedAt"))
          hash[:numberOfOnlineProducts] = number_of_online_products if fields.nil? || (fields.any? && fields.include?("numberOfOnlineProducts"))
          hash[:numberOfOrders] = number_of_orders if fields.nil? || (fields.any? && fields.include?("numberOfOrders"))
          hash[:imageUrl] = image_url if fields.nil? || (fields.any? && fields.include?("imageUrl"))
          hash[:coupons] = coupons if fields.nil? || (fields.any? && fields.include?("coupons"))
          hash[:pictogramUrl] = pictogram_url if fields.nil? || (fields.any? && fields.include?("pictogramUrl"))
          hash[:services] = services if fields.nil? || (fields.any? && fields.include?("services"))
          hash[:isTemplate] = is_template if fields.nil? || (fields.any? && fields.include?("isTemplate"))
          hash[:score] = score if fields.nil? || (fields.any? && fields.include?("score"))
          hash[:indexedAt] = indexed_at if fields.nil? || (fields.any? && fields.include?("indexedAt"))
          hash
        end
      end
    end
  end
end