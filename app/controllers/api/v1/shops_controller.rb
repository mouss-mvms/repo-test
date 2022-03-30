module Api
  module V1
    class ShopsController < ApplicationController
      before_action :uncrypt_token, except: [:show]
      before_action :retrieve_user, except: [:show]
      before_action :check_user, except: [:show, :patch]
      before_action :retrieve_shop, only: [:update, :patch]
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
          shop = Dao::Shop.create(dto_shop_request: shop_request)
          shop.assign_ownership(@user)
          shop.save!
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :created
        end
      end

      def update
        shop_request = Dto::V1::Shop::Request.new(shop_params)
        ActiveRecord::Base.transaction do
          shop = Dao::Shop.update(dto_shop_request: shop_request, shop: @shop)
          response = Dto::V1::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :ok
        end
      end

      def patch
        raise ApplicationController::Forbidden unless @user.is_an_admin? || (@user.is_a_business_user? &&
                                                                            (@shop.owner == @user.shop_employee) &&
                                                                            @shop.deleted_at.blank?)

        ActiveRecord::Base.transaction do
          shop = Dao::Shop.update(dto_shop_request: Dto::V1::Shop::Request.new(update_params), shop: @shop)
          return render json: Dto::V1::Shop::Response.create(shop).to_h, status: :ok
        end
      end

      private

      def retrieve_shop
        raise ActionController::BadRequest.new('Shop_id is incorrect') unless params[:id].to_i > 0
        @shop = Shop.find(params[:id])
      end

      def update_params
        update_params = {}
        update_params[:name] = params[:name]
        update_params[:email] = params[:email]
        update_params[:mobile_number] = params[:mobileNumber]
        update_params[:siret] = params[:siret]
        update_params[:description] = params[:description]
        update_params[:baseline] = params[:baseline]
        update_params[:facebook_link] = params[:facebookLink]
        update_params[:instagram_link] = params[:instagramLink]
        update_params[:website_link] = params[:websiteLink]
        update_params[:address] = {}
        if params[:address]
          address_param = params[:address]
          update_params[:address][:street_number] = address_param.permit(:streetNumber).values.first
          update_params[:address][:route] = address_param.require(:route)
          update_params[:address][:locality] = address_param.require(:locality)
          update_params[:address][:country] = address_param.require(:country)
          update_params[:address][:postal_code] = address_param.permit(:postalCode).values.first
          update_params[:address][:latitude] = address_param.permit(:latitude).values.first
          update_params[:address][:longitude] = address_param.permit(:longitude).values.first
          update_params[:address][:insee_code] = address_param.require(:inseeCode)
        end
        if params[:avatarId]
          update_params[:avatar_id] = params[:avatarId] if Image.find(params[:avatarId])
        elsif params[:avatarUrl]
          update_params[:avatar_url] = params[:avatarUrl]
        end
        if params[:coverId]
          update_params[:cover_id] = params[:coverId] if Image.find(params[:coverId])
        elsif params[:coverUrl]
          update_params[:cover_url] = params[:coverUrl]
        end
        if params[:thumbnailId]
          update_params[:thumbnail_id] = params[:thumbnailId] if Image.find(params[:thumbnailId])
        elsif params[:thumbnailUrl]
          update_params[:thumbnail_url] = params[:thumbnailUrl] unless params[:thumbnailUrl].blank?
        end
        if params[:imageIds]
          update_params[:image_ids] = params[:imageIds] if params[:imageIds].each { |id| Image.find(id) }
        elsif params[:imageUrls]
          update_params[:image_urls] = params[:imageUrls]
        end

        update_params
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
        if params[:avatarId]
          shop_params[:avatar_id] = params[:avatarId] if Image.find(params[:avatarId])
        elsif params[:avatarUrl]
          shop_params[:avatar_url] = params[:avatarUrl]
        end
        if params[:coverId]
          shop_params[:cover_id] = params[:coverId] if Image.find(params[:coverId])
        elsif params[:coverUrl]
          shop_params[:cover_url] = params[:coverUrl]
        end
        if params[:imageIds]
          shop_params[:image_ids] = params[:imageIds] if params[:imageIds].each { |id| Image.find(id) }
        elsif params[:imageUrls]
          shop_params[:image_urls] = params[:imageUrls]
        end

        return shop_params
      end

      def check_user
        raise ApplicationController::Forbidden unless @user.is_a_business_user?
      end

      def is_shop_owner
        raise ApplicationController::Forbidden unless (@shop.owner == @user.shop_employee)
      end
      
    end
  end
end
