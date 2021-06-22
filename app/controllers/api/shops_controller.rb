module Api
  class ShopsController < ApplicationController
    before_action :uncrypt_token, only: [:create]
    before_action :retrieve_user, only: [:create]
    before_action :check_user, only: [:create]

    def show
      unless params[:id].to_i > 0
        error = Dto::Errors::BadRequest.new("#{params[:id]} is not an id valid")
        return render json: error.to_h, status: error.status
      end

      begin
        shop = Shop.find(params[:id].to_i)
        response = Dto::Shop::Response.create(shop)
      rescue ActiveRecord::RecordNotFound => e
        error = Dto::Errors::NotFound.new("Couldn't find #{e.model} with 'id'=#{e.id}")
        return render json: error.to_h, status: error.status
      end

      render json: response.to_h
    end

    def create
      ActiveRecord::Base.transaction do
        begin
          shop = Dto::Shop::Request.new(shop_params).build
          shop.assign_ownership(@user)
          shop.save!
          response = Dto::Shop::Response.create(shop).to_h
        rescue ActionController::ParameterMissing => e
          Rails.logger.error(e.message)
          error = Dto::Errors::BadRequest.new(e.message)
          return render json: error.to_h, status: error.status
        rescue => e
          Rails.logger.error(e.message)
          error = Dto::Errors::InternalServer.new(e.message)
          return render json: error.to_h, status: error.status
        else
          return render json: response.to_h, status: :created
        end
      end
    end

    def shop_params
      shop_params = {}
      shop_params[:name] = params.require(:name)
      shop_params[:email] = params.require(:email)
      shop_params[:siret] = params.require(:siret)
      shop_params[:category_ids] = params.require(:categoryIds)
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

    private

    def check_user
      unless @user.is_a_business_user?
        error = Dto::Errors::Forbidden.new
        return render json: error.to_h, status: error.status
      end
    end
  end
end
