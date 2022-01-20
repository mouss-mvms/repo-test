module Api
  module V1
    class ShopsController < ApplicationController
      before_action :uncrypt_token, except: [:show]
      before_action :retrieve_user, except: [:show]
      before_action :check_user, except: [:show]
      before_action :retrieve_shop, only: [:update]
      before_action :is_shop_owner, only: [:update]

      DEFAULT_FILTERS_SHOPS = [:brands, :services, :categories]
      PER_PAGE = 15

      def show
        raise ActionController::BadRequest.new("#{params[:id]} is not an id valid") unless params[:id].to_i > 0
        shop = Shop.find(params[:id].to_i)
        render json: Dto::V1::Shop::Response.create(shop).to_h, status: :ok if stale?(shop)
      end

      def create
        shop_request = Dto::V1::Shop::Request.new(shop_params)
        ActiveRecord::Base.transaction do
          shop = Dto::V1::Shop.build(dto_shop_request: shop_request)
          shop.assign_ownership(@user)
          shop.save!
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :created
        end
      end

      def update
        shop_request = Dto::V1::Shop::Request.new(shop_params)
        Image.find(shop_request.avatar_image_id) if shop_request.avatar_image_id
        ActiveRecord::Base.transaction do
          shop = Dto::V1::Shop.build(dto_shop_request: shop_request, shop: @shop)
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :ok
        end
      end

      private

      def retrieve_shop
        raise ActionController::BadRequest.new('Shop_id is incorrect') unless params[:id].to_i > 0
        @shop = Shop.find(params[:id])
      end

      def shop_params
        shop_params = {}
        shop_params[:name] = params.require(:name)
        shop_params[:email] = params.require(:email)
        shop_params[:mobile_number] = params.require(:mobileNumber)
        shop_params[:siret] = params.require(:siret)
        shop_params[:description] = params[:description]
        shop_params[:baseline] = params[:baseline]
        shop_params[:facebook_link] = params[:facebookLink]
        shop_params[:instagram_link] = params[:instagramLink]
        shop_params[:website_link] = params[:websiteLink]
        shop_params[:address] = {}
        shop_params[:address][:street_number] = params.require(:address).permit(:streetNumber).values.first
        shop_params[:address][:route] = params.require(:address).require(:route)
        shop_params[:address][:locality] = params.require(:address).require(:locality)
        shop_params[:address][:country] = params.require(:address).require(:country)
        shop_params[:address][:postal_code] = params.require(:address).permit(:postalCode).values.first
        shop_params[:address][:latitude] = params.require(:address).permit(:latitude).values.first
        shop_params[:address][:longitude] = params.require(:address).permit(:longitude).values.first
        shop_params[:address][:insee_code] = params.require(:address).require(:inseeCode)
        shop_params[:avatar_image_id] = params[:avatarImageId]
        return shop_params
      end

      def check_user
        raise ApplicationController::Forbidden unless @user.is_a_business_user?
      end

      def is_shop_owner
        raise ApplicationController::Forbidden unless @shop.owner == @user.shop_employee
      end

    end
  end
end
