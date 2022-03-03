module Api
  module V1
    module Brands
      class SummariesController < ApplicationController
        before_action :render_cache, only: [:search]

        def search
          brands_searchkick_result = ::Requests::BrandSearches.search(query: params[:q], sort_params: params[:sortBy] || SEARCH_DEFAULT_SORT_BY, page: params[:page])
          brands = brands_searchkick_result
          response = Dto::V1::Brand::Search::Response.create(brands: brands, page: brands_searchkick_result.options[:page], total_pages: brands.total_pages, total_count: brands.total_count).to_h
          set_cache!(response: response)
          render json: response, status: :ok
        end

        private

        def cache_params
          {
            q: params[:q],
            sort_params: params[:sortBy],
            page: params[:page]
          }
        end
      end
    end
  end
end
