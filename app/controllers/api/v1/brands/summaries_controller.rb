module Api
  module V1
    module Brands
      class SummariesController < ApplicationController
        def search
          brands_searchkick_result = ::Requests::BrandSearches.search(query: params[:q], sort_params: params[:sortBy], page: params[:page])
          brands = brands_searchkick_result
          response = Dto::V1::Brand::Search::Response.create(brands: brands, page: brands_searchkick_result.options[:page]).to_h
          render json: response, status: :ok
        end
      end
    end
  end
end
