module Api
  module V1
    module Products
      class VariantsController < ApplicationController
        before_action :uncrypt_token, only: [:create, :destroy]
        before_action :retrieve_user, only: [:create, :destroy]

        def destroy
          raise ApplicationController::Forbidden unless @user.is_a_business_user?
          product = Product.find(params[:product_id])
          raise ApplicationController::Forbidden if product.shop.owner != @user.shop_employee
          product.references.find(params[:id]).destroy
        end

        def destroy_offline
          Product.find(params[:product_id]).references.find(params[:id]).destroy
        end

        def create_offline
          params.require(:provider).require(:name)
          params[:provider].require(:name)
          params[:provider].require(:externalVariantId)
          raise ApplicationController::Forbidden if params[:provider][:name] != Product.find(params[:id]).api_provider_product&.api_provider&.name
          dto_variant_request = Dto::V1::Variant::Request.new(variant_params)
          ActiveRecord::Base.transaction do
            variant = Dao::Variant.create(dto_variant_request: dto_variant_request)
            response = Dto::V1::Variant::Response.create(Reference.find(variant.id)).to_h
            return render json: response, status: 201
          end
        end

        def create
          raise ApplicationController::Forbidden unless @user.is_a_business_user?
          product = Product.find(variant_params[:product_id])
          raise ApplicationController::Forbidden if product.shop.owner != @user.shop_employee

          dto_variant_request = Dto::V1::Variant::Request.new(variant_params)
          ActiveRecord::Base.transaction do
            variant = Dao::Variant.create(dto_variant_request: dto_variant_request)
            response = Dto::V1::Variant::Response.create(variant).to_h
            return render json: response, status: 201
          end
        end

        private

        def variant_params
          variant_params = {}
          variant_params[:product_id] = params.require(:id)
          variant_params[:base_price] = params.require(:basePrice)
          variant_params[:weight] = params.require(:weight)
          variant_params[:quantity] = params.require(:quantity)
          variant_params[:is_default] = params.require(:isDefault)
          variant_params[:image_urls] = params[:imageUrls]
          if params[:goodDeal]
            variant_params[:good_deal] = {}
            variant_params[:good_deal][:start_at] = params[:goodDeal].require(:startAt)
            variant_params[:good_deal][:end_at] = params[:goodDeal].require(:endAt)
            variant_params[:good_deal][:discount] = params[:goodDeal].require(:discount)
          end
          variant_params[:characteristics] = []
          params.require(:characteristics).each { |c|
            characteristic = {}
            characteristic[:name] = c.require(:name)
            characteristic[:value] = c.require(:value)
            variant_params[:characteristics] << characteristic
          }
          if params[:provider]
            variant_params[:provider] = {}
            variant_params[:provider][:name] = params[:provider][:name] if params[:provider][:name]
            variant_params[:provider][:external_variant_id] = params[:provider][:externalVariantId] if params[:provider][:externalVariantId]
          end
          variant_params
        end
      end
    end
  end
end
