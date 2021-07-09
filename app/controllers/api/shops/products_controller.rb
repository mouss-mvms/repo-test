module Api
  module Shops
    class ProductsController < ApplicationController
      before_action :check_shop

      def index
        products = @shop.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
        response = products.map {|product| Dto::Product::Response.create(product)}
        paginate json: response, per_page: 50
      end

      private

      def check_shop
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: error.status
        end

        begin
          @shop = Shop.find(route_params[:id])
        rescue ActiveRecord::RecordNotFound => e
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: error.status
        end
      end

      def route_params
        params.permit(:id)
      end
    end
  end
end
