module Api
  module V1
    module Shops
      class ProductsController < ApplicationController
        before_action :check_shop
        DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services]
        PER_PAGE = 15
        QUERY_ALL = '*'

        def index
          search_criterias = ::Criterias::Composite.new(::Criterias::Products::FromShop.new(@shop.id))
                                                   .and(::Criterias::Products::Online)
          if search_params[:categories]
            category_ids = Category.where(slug: search_params[:categories].split('__')).pluck(:id).uniq
            search_criterias = search_criterias.and(::Criterias::InCategories.new(category_ids))
          end

          search_criterias = filter_by(search_criterias)
          sort_by = search_params[:sort_by] ? search_params[:sort_by] : 'position'
          sort_by = Requests::ProductSearches.new.sort_by(sort_by)
          query = search_params[:search_query] ? search_params[:search_query] : QUERY_ALL

          products = Product.search(query, where: search_criterias.create, order: sort_by, page: search_params[:page], per_page: PER_PAGE)
          response = products.map {|product| Dto::V1::Product::Response.create(product)}
          render json: response, per_page: PER_PAGE
        end

        private

        def check_shop
          raise ActionController::BadRequest.new('Shop_id is incorrect') unless route_params[:id].to_i > 0
          @shop = Shop.find(route_params[:id])
        end

        def route_params
          params.permit(:id)
        end

        def search_params
          params.permit(:search_query, :categories, :prices, :services, :sort_by, :page)
        end

        def filter_by(search_criterias)
          DEFAULT_FILTERS_PRODUCTS.each do |key|
            splited_values = params[key.to_s]&.split('__')
            if splited_values
              splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
              module_name = key.to_s.titleize
              begin
                search_criterias.and("::Criterias::Products::From#{module_name}".constantize.new(splited_values))
              rescue; end
            end
          end
          search_criterias
        end
      end
    end

  end
end