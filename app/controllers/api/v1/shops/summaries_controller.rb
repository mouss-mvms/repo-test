module Api
  module V1
    module Shops
      class SummariesController < ApplicationController

        RESULT_PER_PAGE = 16
        MIN_PER_PAGE = 1
        MAX_PER_PAGE = 32

        def search
          search_parameters = search_params
          raise ActionController::BadRequest.new("perPage params must be an integer between #{MIN_PER_PAGE} and #{MAX_PER_PAGE}.") unless search_parameters[:per_page].blank? || (search_parameters[:per_page].is_a?(Integer) && search_parameters[:per_page].between?(MIN_PER_PAGE, MAX_PER_PAGE))
          search_criterias = ::Criterias::Composite.new(::Criterias::Shops::NotDeleted)
                                                   .and(::Criterias::Shops::NotTemplated)
                                                   .and(::Criterias::NotInHolidays)

          search_criterias.and(::Criterias::Shops::WithOnlineProducts) unless params[:includeOffline] == true
          if search_parameters[:geoloc]
            geoloc_params = search_parameters[:geoloc]
            radius_in_km = (geoloc_params[:radius].to_f / 1000)
            search_criterias.and(::Criterias::Shops::InPerimeter.new(geoloc_params[:latitude], geoloc_params[:longitude], radius_in_km))
          elsif search_parameters[:location]
            territory = Territory.find_by(slug: search_parameters[:location])
            city = City.find_by(slug: search_parameters[:location])
            if territory
              search_criterias.and(::Criterias::InTerritory.new(territory.slug))
              insee_code = territory.insee_codes
            elsif city
              search_criterias.and(::Criterias::InCities.new(city.insee_code))
              insee_code = city.insee_code
            else
              raise ApplicationController::NotFound.new('Location not found')
            end
            if search_parameters[:perimeter]
              search_criterias.remove(:insee_code, :territory_slug)
              case search_parameters[:perimeter]
              when 'department'
                search_criterias.and(::Criterias::CloseToYou.new(nil, insee_code, except_current_cities: search_parameters[:exclude_location]))
              when 'country'
                search_criterias.and(::Criterias::InCountry.new(insee_code, except_current_department: search_parameters[:exclude_location]))
              end
            end
          else
            search_criterias.and(::Criterias::InCountry.new(nil))
          end

          search_criterias.and(::Criterias::Shops::FromServices.new(search_parameters[:services])) if search_parameters[:services]

          if search_parameters[:category]
            category = Category.find_by!(slug: search_parameters[:category])
            search_criterias.and(::Criterias::InCategories.new([category.id]))
          end

          search_results = ::Requests::ShopSearches.new(
            query: search_parameters[:query],
            criterias: search_criterias.create,
            aggs: [:brands_name, :services, :category_tree_ids, :category_id],
            sort_params: search_parameters[:sort_by],
            pagination: { page: search_parameters[:page], per_page: search_parameters[:per_page] || RESULT_PER_PAGE },
            random: search_parameters[:random]
          ).call

          search = { shops: search_results.map { |s| s },
                     aggs: search_results.aggs,
                     page: search_results.options[:page],
                     total_pages: search_results.total_pages,
                     total_count: search_results.total_entries }

          render json: Dto::V1::Shop::Search::Response.create(search).to_h, status: :ok
        end

        private

        def search_params
          search_params = {}
          search_params[:location] = params[:location].parameterize if params[:location]
          if params[:geolocOptions]
            geoloc = {}
            geoloc[:longitude] = params[:geolocOptions].require(:long)
            geoloc[:latitude] = params[:geolocOptions].require(:lat)
            geoloc[:radius] = !params[:geolocOptions][:radius] || params[:geolocOptions][:radius] <= 0.0 ? 0.5 : params[:geolocOptions][:radius]
            search_params[:geoloc] = geoloc
          end
          search_params[:query] = params[:q] if params[:q]
          search_params[:is_random] = params[:random] if params[:random]
          search_params[:perimeter] = params[:perimeter] if params[:perimeter]
          search_params[:category] = params[:category] if params[:category]
          search_params[:sort_by] = params[:sortBy].blank? ? SEARCH_DEFAULT_SORT_BY : params[:sortBy]
          search_params[:random] = params[:sortBy] && params[:sortBy] == 'random'
          search_params[:page] = params[:page] ? params[:page] : "1"
          search_params[:per_page] = params[:perPage] if params[:perPage]
          search_params[:exclude_location] = (params[:excludeLocation] == true)
          search_params[:services] = params[:services]
          search_params
        end
      end
    end
  end
end
