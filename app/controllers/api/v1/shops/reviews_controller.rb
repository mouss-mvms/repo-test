module Api
  module V1
    module Shops
      class ReviewsController < ApplicationController
        before_action :uncrypt_token
        before_action :retrieve_user

        def create
          Shop.find(params[:id])
          review = Review.create!(review_params.merge(shop_id: params[:id], user_id: @user.id))

          render json: Dto::V1::Review::Response.create(review).to_h, status: :created
        end

        private

        def review_params
          raise ActionController::BadRequest.new("mark is not required") if params[:parentId] && params[:mark]
          review_params = {}
          review_params[:content] = params.require(:content)
          review_params[:mark] = params.require(:mark) unless params[:parentId]
          review_params[:parent_id] = params[:parentId]
          review_params
        end
      end
    end
  end
end
