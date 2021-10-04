module Api
  module V1
    module Shops
      class DeliveriesController < ApplicationController
        before_action :check_shop
        before_action :uncrypt_token, only: [:update]
        before_action :retrieve_user, only: [:update]

        SELF_DELIVERY_SLUG = "livraison-par-le-commercant".freeze

        def index
          deliveries = @shop.active_services
          response = deliveries.map { |delivery| Dto::V1::Delivery::Response.create(delivery).to_h }

          render json: response, status: :ok
        end

        def update
          raise ApplicationController::Forbidden.new if @shop.owner.user.id != @user.id

          unable_delivery_options(shop: @shop)

          deliveries_params[:service_slugs].each do |service_slug|
            service = Service.find_by(slug: service_slug)
            shop_delivery_option = DeliveryOption.find_by(shop_id: @shop.id, service_id: service.id)
            shop_delivery_option.is_enabled = true
            shop_delivery_option.save!

            if service_slug == SELF_DELIVERY_SLUG
              @shop.is_self_delivery = true
              @shop.self_delivery_price = deliveries_params[:self_delivery_price]
              @shop.free_delivery_price = deliveries_params[:free_shipping_amount] if deliveries_params[:free_shipping_amount]
              @shop.save!
            end
          end

          deliveries = @shop.active_services
          response = deliveries.map { |delivery| Dto::V1::Delivery::Response.create(delivery).to_h }

          render json: response, status: :ok
        end

        private

        def check_shop
          raise ActionController::BadRequest.new("Shop_id is incorrect") unless params[:id].to_i > 0
          @shop = Shop.find(params[:id])
        end

        def deliveries_params
          deliveries_params = {}
          deliveries_params[:service_slugs] = params.require(:serviceSlugs)
          if deliveries_params[:service_slugs].include?(SELF_DELIVERY_SLUG)
            deliveries_params[:free_shipping_amount] = params[:freeShippingAmount]
            raise ActionController::BadRequest.new("freeShippingAmount must be at least 1.0") if deliveries_params[:free_shipping_amount] && deliveries_params[:free_shipping_amount].to_f < 1

            deliveries_params[:self_delivery_price] = params.require(:selfDeliveryPrice)
            raise ActionController::BadRequest.new("selfDeliveryPrice must be non null") unless deliveries_params[:self_delivery_price].to_f > 0.0
          end
          deliveries_params
        end

        def unable_delivery_options(shop:)
          shop.delivery_options.update_all(is_enabled: false)
          shop.update!(is_self_delivery: false)
        end
      end
    end
  end
end
