module Api
  module Citizens
    class ProductsController < ApplicationController
      before_action :check_citizen

      def index
        products = @citizen.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
        response = products.map {|product| Dto::Product::Response.create(product)}
        render json: response, status: :ok
      end

      private

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
