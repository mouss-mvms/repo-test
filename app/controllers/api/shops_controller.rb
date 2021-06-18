module Api
  class ShopsController < ApplicationController

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
  end
end
