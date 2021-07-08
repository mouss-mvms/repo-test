module Api
  module Citizens
    class ProductsController < ApplicationController
      before_action :check_citizen
      before_action :check_product

      def show
        render json: Dto::Product::Response.create(@product).to_h, status: :ok
      end

      private

      def check_product
        unless params[:product_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        products_citizen = Product.joins(:citizens).where("citizens.id = ?", @citizen.id)
        @product = products_citizen.where(id: params[:product_id]).first
        raise ActiveRecord::RecordNotFound.new("Couldn't find product #{params[:product_id]} for citizen #{params[:id]}") unless @product
      end

      def check_citizen
        unless params[:id].to_i > 0
          Rails.logger.error("check_citizen: Shop_id is incorrect")
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: error.status
        end
        @citizen = Citizen.find(params[:id])
      end
    end
  end
end
