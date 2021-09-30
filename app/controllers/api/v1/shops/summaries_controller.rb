module Api
  module V1
    module Shops
      class SummariesController < ApplicationController
        before_action :set_location

        DEFAULT_FILTERS_SHOPS = [:brands, :services, :categories]
        PER_PAGE = 15

        def index
          render json: get, status: :ok
        end

        def search
          search_criterias = ::Criterias::Composite.new(::Criterias::Shops::WithOnlineProducts)
                                                   .and(::Criterias::Shops::NotDeleted)
                                                   .and(::Criterias::Shops::NotTemplated)
                                                   .and(::Criterias::NotInHolidays)

          search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless params[:q]

          if params[:categories]
            @category = Category.find_by(slug: params[:categories])
            raise ApplicationController::NotFound.new('Category not found.') unless @category
            search_criterias.and(::Criterias::InCategories.new([@category.id]))
          end

          set_close_to_you_criterias(search_criterias, params[:more])
          search_criterias = filter_by(search_criterias)

          highest_scored_shops = ::Requests::ShopSearches.search_highest_scored_shops(params[:q], search_criterias)

          search_criterias = filter_shops(search_criterias, highest_scored_shops) unless params[:more]

          search_criterias.and(::Criterias::Shops::ExceptShops.new(highest_scored_shops.map(&:slug)))

          random_shops = ::Requests::ShopSearches.search_random_shops(params[:q], search_criterias, params[:page])

          if params[:q]
            product_shops = shops_from_product(search_criterias, params[:q], random_shops)
          end

          unless highest_scored_shops.present? && random_shops.present?
            set_close_to_you_criterias(search_criterias, true)
            random_shops = ::Requests::ShopSearches.search_random_shops(params[:q], search_criterias, params[:page])
          end





          if  params[:page] || params[:more]
            shop_summaries = random_shops
          else
            shop_summaries = highest_scored_shops.response['hits']['hits'].concat(random_shops.response['hits']['hits'])
          end

          if params[:q]
            shop_summaries = shop_summaries.response['hits']['hits'].concat(product_shops.response['hits']['hits'])
          end

          aggs = params[:more] || params[:q] ? random_shops.aggs : highest_scored_shops.aggs
          aggs = aggs.merge!(product_shops.aggs) if params[:q]

          render json: Dto::V1::Shop::Search::Response.new({shops: shop_summaries, filters: aggs, page: 1}), status: :ok
        end

        private

        def get
          search_criterias = ::Criterias::Composite.new(::Criterias::Shops::WithOnlineProducts)
                                                   .and(::Criterias::Shops::NotDeleted)
                                                   .and(::Criterias::Shops::NotTemplated)
                                                   .and(::Criterias::NotInHolidays)

          search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless params[:q]

          if params[:categories]
            @category = Category.find_by(slug: params[:categories])
            raise ApplicationController::NotFound.new('Category not found.') unless @category
            search_criterias.and(::Criterias::InCategories.new([@category.id]))
          end

          set_close_to_you_criterias(search_criterias, params[:more])
          search_criterias = filter_by(search_criterias)

          highest_scored_shops = ::Requests::ShopSearches.search_highest_scored_shops(params[:q], search_criterias)

          search_criterias = filter_shops(search_criterias, highest_scored_shops) unless params[:more]

          search_criterias.and(::Criterias::Shops::ExceptShops.new(highest_scored_shops.map(&:slug)))

          random_shops = ::Requests::ShopSearches.search_random_shops(params[:q], search_criterias, params[:page])

          if params[:q]
            product_shops = shops_from_product(search_criterias, params[:q], random_shops)
          end

          unless highest_scored_shops.present? && random_shops.present?
            set_close_to_you_criterias(search_criterias, true)
            random_shops = ::Requests::ShopSearches.search_random_shops(params[:q], search_criterias, params[:page])
          end

          build_shop_summaries_response(highest_scored_shops, random_shops, product_shops, params[:page], params[:more], params[:q], params[:fields])
        end

        def filter_shops(search_criterias, shops)
          slugs = shops.pluck(:slug)
          search_criterias.and(::Criterias::Shops::ExceptShops.new(slugs))
        end

        def set_location
          raise ActionController::ParameterMissing.new('location.') if params[:location].blank?
          @territory = Territory.find_by(slug: params[:location])
          @city = City.find_by(slug: params[:location])
          raise ApplicationController::NotFound.new('Location not found.') unless @city || @territory
        end

        def set_close_to_you_criterias(search_criterias, see_more)
          insee_codes = @territory ? @territory.insee_codes : @city.insee_codes

          if see_more
            return search_criterias.and(::Criterias::CloseToYou.new(@city, insee_codes))
          else
            return set_perimeter(search_criterias, insee_codes)
          end
        end

        def set_perimeter(search_criterias, insee_codes)
          if params[:q] && !@category
            search_criterias.and(::Criterias::InCities.new(insee_codes))
          else
            case params[:perimeter]
            when "around_me" then search_criterias.and(::Criterias::CloseToYou.new(@city, insee_codes, current_cities_accepted: true))
            when "all" then search_criterias.and(::Criterias::HasServices.new(["livraison-par-colissimo"]))
            else search_criterias.and(::Criterias::InCities.new(insee_codes))
            end
          end

          return search_criterias
        end

        def filter_by(search_criterias)
          DEFAULT_FILTERS_SHOPS.each do |key|
            splited_values = params[key.to_s]&.split('__')
            if splited_values
              splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
              module_name = key.to_s.titleize
              begin
                search_criterias.and("::Criterias::Shops::From#{module_name}".constantize.new(splited_values))
              rescue; end
            end
          end
          search_criterias
        end

        def build_shop_summaries_response(highest_scored_shops, random_shops, product_shops, page, see_more, query, fields)
          random_shop_summaries = random_shops.map { |shop| Dto::V1::ShopSummary::Response.create(shop.deep_symbolize_keys).to_h(fields) }
          if page || see_more
            shop_summaries = random_shop_summaries
          else
            highest_scored_shop_summaries = highest_scored_shops.map { |shop| Dto::V1::ShopSummary::Response.create(shop.deep_symbolize_keys).to_h(fields) }
            shop_summaries = highest_scored_shop_summaries.concat(random_shop_summaries)
          end

          if query
            product_shop_summaries = product_shops.map { |shop| Dto::V1::ShopSummary::Response.create(shop.deep_symbolize_keys).to_h(fields) }
            shop_summaries = shop_summaries.concat(product_shop_summaries)
          end

          shop_summaries
        end
      end
    end
  end
end
