module Api
  module V1
    module Products
      class SummariesController < ApplicationController
        before_action :render_cache, only: [:search]

        RESULTS_PER_PAGE = 16

        def search
          search_criterias = ::Criterias::Composite.new(::Criterias::Products::Online)
                                                   .and(::Criterias::Products::NotInShopTemplate)
                                                   .and(::Criterias::NotInHolidays)

          if search_params[:location]
            territory = Territory.find_by(slug: search_params[:location])
            city = City.find_by(slug: search_params[:location])
            if territory
              search_criterias.and(::Criterias::InTerritory.new(territory.slug))
              insee_codes = territory.insee_codes
            elsif city
              search_criterias.and(::Criterias::InCities.new(city.insee_codes))
              insee_codes = city.insee_codes
            else
              raise ApplicationController::NotFound.new('Location not found')
            end
            if search_params[:perimeter]
              case search_params[:perimeter]
              when 'department'
                search_criterias.and(::Criterias::CloseToYou.new(nil, insee_codes, except_current_cities: true))
              when 'country'
                search_criterias.remove(:insee_code, :territory_slug)
                search_criterias.and(::Criterias::InCountry.new(nil))
              end
            end
          else
            search_criterias.and(::Criterias::InCountry.new(nil))
          end

          search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless search_params[:q]
          search_criterias.and(::Criterias::Products::SharedByCitizen) if search_params[:shared_products] == true
          search_criterias.and(::Criterias::Products::FromServices.new(search_params[:services])) if search_params[:services]

          if search_params[:category]
            category = Category.find_by!(slug: search_params[:category])
            search_criterias.and(::Criterias::InCategories.new([category.id]))
          end

          search_results = ::Requests::ProductSearches.new(
            query: search_params[:q],
            criterias: search_criterias.create,
            sort_params: search_params[:sort_by],
            random: search_params[:random],
            aggs: [:base_price, :brand_name, :colors, :sizes, :services, :category_tree_ids],
            pagination: { page: search_params[:page], per_page: RESULTS_PER_PAGE }
          ).call

          search = { products: search_results.map { |p| p }, aggs: search_results.aggs, page: search_results.options[:page], total_pages: search_results.total_pages }

          response = ::Dto::V1::Product::Search::Response.create(search).to_h

          set_cache!(response: response)

          render json: response, status: 200
        end

        private

        def search_params
          search_params = {}
          search_params[:location] = params[:location].parameterize if params[:location].present?
          search_params[:perimeter] = params[:perimeter] if params[:perimeter]
          search_params[:q] = params[:q] if params[:q].present?
          search_params[:shared_products] = params[:sharedProducts] if params[:sharedProducts]
          search_params[:category] = params[:category] if params[:category].present?
          search_params[:services] = params[:services] if params[:services]
          search_params[:sort_by] = params[:sortBy] ? params[:sortBy] : 'name-asc'
          search_params[:random] = params[:sortBy] == 'random'
          search_params[:page] = params[:page] ? params[:page] : "1"
          search_params
        end

        def cache_params
          search_params
        end
      end
    end
  end
end