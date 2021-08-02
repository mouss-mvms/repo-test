module Api
  module Shops
    class ProductsController < ApplicationController
      before_action :check_shop
      DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services]
      PER_PAGE = 15

      def index
        search_criterias = ::Criterias::Composite.new(::Criterias::Products::FromShop.new(@shop.id))
                                                 .and(::Criterias::Products::Online)
        if params[:categories]
          category_ids = Category.where(slug: params[:categories].split('__')).pluck(:id).uniq
          search_criterias = search_criterias.and(::Criterias::InCategories.new(category_ids))
        end


        search_criterias = filter_by(search_criterias)
        sort_params = params[:sort_by] ? Requests::ProductSearches.new.sort_by(params[:sort_by]) : nil

        products = Product.search('*', where: search_criterias.create, order: sort_params, page: params[:page], per_page: PER_PAGE)
        response = products.map {|product| Dto::Product::Response.create(product)}
        render json: response
      end

      private

      def check_shop
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: error.status
        end
        @shop = Shop.find(route_params[:id])
      end

      def route_params
        params.permit(:id)
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
