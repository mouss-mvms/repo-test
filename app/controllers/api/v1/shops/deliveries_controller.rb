module Api
  module V1
    module Shops
      class DeliveriesController < ApplicationController
        before_action :check_shop

        def index
          deliveries = @shop.services
          response = deliveries.map { |delivery| Dto::V1::Delivery::Response.create(delivery).to_h }

          render json: response, status: :ok
        end

        private

        def check_shop
          raise ActionController::BadRequest.new('Shop_id is incorrect') unless params[:id].to_i > 0
          @shop = Shop.find(params[:id])
        end
      end
    end
  end
end
