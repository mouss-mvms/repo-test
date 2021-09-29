module Api
  module V1
    module Shops
      class ReviewsController < ApplicationController
        before_action :uncrypt_token, only: [:create]
        before_action :retrieve_user, only: [:create]

        def index
          shop = ::Shop.find(params[:id])
          reviews = shop.reviews
          render json: reviews.map { |review| Dto::V1::Review::Response.create(review).to_h }, status: :ok
        end

        def create
          Shop.find(params[:id])
          review = Review.create!(review_params.merge(shop_id: params[:id], user_id: @user.id))

          render json: Dto::V1::Review::Response.create(review).to_h, status: :created
        end

        private

        def review_params
          raise ActionController::BadRequest.new("mark is not required") if params[:parentId] && params[:mark]
          raise ActionController::BadRequest.new("mark must be between 0 and 5") if params[:mark] && ((params[:mark].to_i < 0) || (params[:mark].to_i > 5))
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
