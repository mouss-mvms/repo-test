module Api
  module V1
    class BrandsController < ApplicationController
      before_action :uncrypt_token, only: [:create]
      before_action :retrieve_user, only: [:create]
      before_action :check_pro_user, only: [:create]

      def create
        brand = Brand.create!(brand_params)
        response = Dto::V1::Brand::Response.create(brand: brand).to_h
        render json: response, status: :created
      end

      private

      def brand_params
        raise ApplicationController::Conflict.new("A brand named '#{params[:name]}' already exists.}") if Brand.where('LOWER(name) LIKE ?', "#{params[:name].downcase}").present?

        brand_params = {}
        brand_params[:name] = params.require(:name)
        brand_params
      end

      def check_pro_user
        raise ApplicationController::Forbidden.new unless @user.is_a_pro?
      end
    end
  end
end
