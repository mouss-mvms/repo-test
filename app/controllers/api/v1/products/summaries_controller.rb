module Api
  module V1
    module Products
      class SummariesController < ApplicationController
        before_action :set_location, only: [:index, :search]

        DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services, :categories]

        def index
          search_criterias = ::Criterias::Composite.new(::Criterias::Products::Online)
                                                  .and(::Criterias::Products::NotInShopTemplate)
                                                  .and(::Criterias::NotInHolidays)

          search_criterias.and(::Criterias::Products::OnDiscount) if params[:sort_by] == 'discount'

          search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless params[:q]

          if params[:categories]
            @category = Category.find_by(slug: params[:categories])
            raise ApplicationController::NotFound.new('Category not found.') unless @category
            search_criterias.and(::Criterias::InCategories.new([@category.id]))
          end

          set_close_to_you_criterias(search_criterias, params[:more])
          search_criterias = filter_by(search_criterias)

          unless params[:q]
            search_highest = ::Requests::ProductSearches.search_highest_scored_products(params[:q], search_criterias)
            highest_scored_products = search_highest.products

            unless params[:sort_by] || params[:more]
              search = search_highest
              search_criterias = filter_products(search_criterias, highest_scored_products)
            end

            search_criterias.and(::Criterias::Products::ExceptProducts.new(highest_scored_products.map(&:id)))
          end

          random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])

          if params[:more] && random_products.empty?
            search_criterias.remove(:insee_code, :department_number)
            random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])
          end

          unless highest_scored_products.present? && random_products.present?
            set_close_to_you_criterias(search_criterias, true)
            random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])
          end

          product_summaries = set_products!(highest_scored_products, random_products, params[:page], params[:more], params[:sort_by])

          render json: product_summaries, status: 200
        end

        def search
          search_criterias = ::Criterias::Composite.new(::Criterias::Products::Online)
                                                   .and(::Criterias::Products::NotInShopTemplate)
                                                   .and(::Criterias::NotInHolidays)

          search_criterias.and(::Criterias::Products::OnDiscount) if params[:sort_by] == 'discount'

          search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless params[:q]

          if params[:categories]
            @category = Category.find_by(slug: params[:categories])
            raise ApplicationController::NotFound.new('Category not found.') unless @category
            search_criterias.and(::Criterias::InCategories.new([@category.id]))
          end

          set_close_to_you_criterias(search_criterias, params[:more])
          search_criterias = filter_by(search_criterias)

          unless params[:q]
            search_highest = ::Requests::ProductSearches.search_highest_scored_products(params[:q], search_criterias)
            highest_scored_products = search_highest.products

            unless params[:sort_by] || params[:more]
              search = search_highest
              search_criterias = filter_products(search_criterias, highest_scored_products)
            end

            search_criterias.and(::Criterias::Products::ExceptProducts.new(highest_scored_products.map(&:id)))
          end

          random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])

          if params[:more] && random_products.empty?
            search_criterias.remove(:insee_code, :department_number)
            random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])
          end


          unless params[:sort_by] || params[:more] || params[:q]
            aggs = search_highest.aggs
          else
            aggs = random_products.aggs
          end

          unless highest_scored_products.present? && random_products.present?
            set_close_to_you_criterias(search_criterias, true)
            random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])
            aggs = random_products.aggs
          end

          products_search  =  (params[:sort_by] || params[:more] || params[:q]) ? random_products.map {|p| p} :  highest_scored_products.concat(random_products.map { |p| p })

          search = { products: products_search, aggs: aggs, page: params[:page] }


          response = ::Dto::V1::Product::Search::Response.create(search).to_h

          render json: response, status: 200
        end

        private

        def set_location
          raise ActionController::ParameterMissing.new('location') if params[:location].blank?
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
          if params[:search_query] && !@category
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
          DEFAULT_FILTERS_PRODUCTS.each do |key|
            splited_values = params[key.to_s]&.split('__')
            if splited_values
              splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
              module_name = key.to_s.titleize
              begin
                search_criterias.and("::Criterias::Products::From#{module_name}".constantize.new(splited_values))
              rescue
                raise ApplicationController::InternalServerError.new
              end
            end
          end
          search_criterias
        end

        def filter_products(search_criterias, products)
          ids = products.pluck(:id).map(&:to_i)
          search_criterias.and(::Criterias::Products::ExceptProducts.new(ids))
        end

        def set_products!(highest_scored_products, random_products, page, see_more, sort_by)
          product_summaries = random_products.map { |product| Dto::V1::ProductSummary::Response.create(product.deep_symbolize_keys).to_h }
          if page || see_more || sort_by
            product_summaries
          else
            highest_scored_product_summaries = highest_scored_products.map { |product| Dto::V1::ProductSummary::Response.create(product.deep_symbolize_keys).to_h }
            highest_scored_product_summaries.concat(product_summaries)
          end
        end
      end
    end
  end
end