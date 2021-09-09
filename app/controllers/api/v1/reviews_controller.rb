module Api
  module V1
    class ReviewsController < ApplicationController
      before_action :uncrypt_token
      before_action :retrieve_user

      def update
        review = Review.find(params[:id])
        raise ApplicationController::Forbidden.new('') if review.user != @user
        raise ActionController::BadRequest.new('param is missing or the value is empty: content') if params[:content] && params[:content].blank?
        review.content = params[:content] if params[:content]
        review.mark = params[:mark] if params[:mark]
        review.warned = params[:isWarned] if params[:isWarned]
        review.save!

        return render json: Dto::V1::Review::Response.create(review).to_h, status: :ok
      end
    end
  end
end
