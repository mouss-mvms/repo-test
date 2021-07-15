module Api
  class ShopsController < ApplicationController
    before_action :uncrypt_token, except: [:show]
    before_action :retrieve_user, except: [:show]
    before_action :check_user, except: [:show]
    before_action :retrieve_shop, only: [:update]
    before_action :is_shop_owner, only: [:update]

    def show
      unless params[:id].to_i > 0
        error = Dto::Errors::BadRequest.new(detail: "#{params[:id]} is not an id valid")
        return render json: error.to_h, status: error.status
      end

      begin
        shop = Shop.find(params[:id].to_i)
      rescue ActiveRecord::RecordNotFound => e
        error = Dto::Errors::NotFound.new(detail: "Couldn't find #{e.model} with 'id'=#{e.id}")
        return render json: error.to_h, status: error.status
      else
        response = Dto::Shop::Response.create(shop)
        render json: response.to_h, status: :ok
      end

    end

    def create
      ActiveRecord::Base.transaction do
        begin
          shop_request = Dto::Shop::Request.new(shop_params)
          shop = Dto::Shop.build(dto_shop_request: shop_request)
          shop.assign_ownership(@user)
          shop.save!
        rescue ActionController::ParameterMissing => e
          Rails.logger.error(e.message)
          error = Dto::Errors::BadRequest.new(detail: e.message)
          return render json: error.to_h, status: error.status
        rescue => e
          Rails.logger.error(e.message)
          error = Dto::Errors::InternalServer.new(detail: e.message)
          return render json: error.to_h, status: error.status
        else
          response = Dto::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :created
        end
      end
    end

    def update
      ActiveRecord::Base.transaction do
        begin
          shop_request = Dto::Shop::Request.new(shop_params)
          shop = Dto::Shop.build(dto_shop_request: shop_request, shop: @shop)
        rescue ActionController::ParameterMissing => e
          Rails.logger.error(e.message)
          error = Dto::Errors::BadRequest.new(e.message)
          return render json: error.to_h, status: error.status
        rescue => e
          Rails.logger.error(e.message)
          error = Dto::Errors::InternalServer.new
          return render json: error.to_h, status: error.status
        else
          response = Dto::Shop::Response.create(shop).to_h
          return render json: response.to_h, status: :ok
        end
      end
    end

    private

    def retrieve_shop
      unless params[:id].to_i > 0
        error = Dto::Errors::BadRequest.new(detial: 'Shop_id is incorrect')
        return render json: error.to_h, status: error.status
      end

      begin
        @shop = Shop.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        error = Dto::Errors::NotFound.new(detail: e.message)
        return render json: error.to_h, status: error.status
      end
    end

    def shop_params
      shop_params = {}
      shop_params[:name] = params.require(:name)
      shop_params[:email] = params.require(:email)
      shop_params[:siret] = params.require(:siret)
      shop_params[:description] = params[:description]
      shop_params[:baseline] = params[:baseline]
      shop_params[:facebook_link] = params[:facebookLink]
      shop_params[:instagram_link] = params[:instagramLink]
      shop_params[:website_link] = params[:websiteLink]
      shop_params[:address] = {}
      shop_params[:address][:street_number] = params.require(:address).permit(:streetNumber).values.first
      shop_params[:address][:route] = params.require(:address).permit(:route).values.first
      shop_params[:address][:locality] = params.require(:address).permit(:locality).values.first
      shop_params[:address][:country] = params.require(:address).permit(:country).values.first
      shop_params[:address][:postal_code] = params.require(:address).permit(:postalCode).values.first
      shop_params[:address][:latitude] = params.require(:address).permit(:latitude).values.first
      shop_params[:address][:longitude] = params.require(:address).permit(:longitude).values.first
      return shop_params
    end

    def check_user
      unless @user.is_a_business_user?
        error = Dto::Errors::Forbidden.new
        return render json: error.to_h, status: error.status
      end
    end

    def is_shop_owner
      unless @shop.owner == @user.shop_employee
        error = Dto::Errors::Forbidden.new
        return render json: error.to_h, status: error.status
      end
    end
  end
end
