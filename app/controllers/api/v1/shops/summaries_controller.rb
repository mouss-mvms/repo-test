module Api
  module V1
    module Shops
      class SummariesController < ApplicationController

        RESULT_PER_PAGE = 16
        MIN_PER_PAGE = 1
        MAX_PER_PAGE = 32

        def search
          raise ActionController::BadRequest.new("perPage params must be an integer between #{MIN_PER_PAGE} and #{MAX_PER_PAGE}.") unless search_params[:per_page].blank? || (search_params[:per_page].is_a?(Integer) && search_params[:per_page].between?(MIN_PER_PAGE, MAX_PER_PAGE))
          search_criterias = ::Criterias::Composite.new(::Criterias::Shops::WithOnlineProducts)
                                                   .and(::Criterias::Shops::NotDeleted)
                                                   .and(::Criterias::Shops::NotTemplated)
                                                   .and(::Criterias::NotInHolidays)

          if search_params[:geoloc]
            geoloc_params = search_params[:geoloc]
            radius_in_km = (geoloc_params[:radius].to_f / 1000)
            search_criterias.and(::Criterias::Shops::InPerimeter.new(geoloc_params[:latitude], geoloc_params[:longitude], radius_in_km))
          elsif search_params[:location]
            territory = Territory.find_by(slug: search_params[:location])
            city = City.find_by(slug: search_params[:location])
            if territory
              search_criterias.and(::Criterias::InTerritory.new(territory.slug))
              insee_code = territory.insee_codes
            elsif city
              search_criterias.and(::Criterias::InCities.new(city.insee_code))
              insee_code = city.insee_code
            else
              raise ApplicationController::NotFound.new('Location not found')
            end
            if search_params[:perimeter]
              search_criterias.remove(:insee_code, :territory_slug)
              case search_params[:perimeter]
              when 'department'
                search_criterias.and(::Criterias::CloseToYou.new(nil, insee_code, except_current_cities: search_params[:exclude_location]))
              when 'country'
                search_criterias.and(::Criterias::InCountry.new(insee_code, except_current_department: search_params[:exclude_location]))
              end
            end
          else
            search_criterias.and(::Criterias::InCountry.new(nil))
          end

          search_criterias.and(::Criterias::Shops::FromServices.new(search_params[:services])) if search_params[:services]

          if search_params[:category]
            category = Category.find_by!(slug: search_params[:category])
            search_criterias.and(::Criterias::InCategories.new([category.id]))
          end

          shops = ::Requests::ShopSearches.new(
            query: search_params[:query],
            criterias: search_criterias.create,
            aggs: [:brands_name, :services, :category_tree_ids, :category_id],
            sort_params: search_params[:sort_by],
            pagination: { page: search_params[:page], per_page: search_params[:per_page] || RESULT_PER_PAGE },
            random: search_params[:random]
          ).call

          render json: Dto::V1::Shop::Search::Response.new({ shops: shops.map { |p| p }, aggs: shops.aggs, page: shops.options[:page], total_pages: shops.total_pages }).to_h, status: :ok
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
          search_params[:sort_by] = params[:sortBy] ? params[:sortBy] : 'name-asc'
          search_params[:random] = params[:sortBy] && params[:sortBy] == 'random'
          search_params[:page] = params[:page] ? params[:page] : "1"
          search_params[:per_page] = params[:perPage] if params[:perPage]
          search_params[:exclude_location] = (params[:excludeLocation] == false)
          search_params[:services] = params[:services]
          search_params
        end
      end
    end
  end
end
