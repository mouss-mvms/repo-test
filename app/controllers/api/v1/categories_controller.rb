module Api
  module V1
    class CategoriesController < ApplicationController

      def show
        if params[:children].present?
          raise ActionController::BadRequest.new('children must be true or false.') unless %w(true false).include?(params[:children])
        end
        category = Category.find(params[:id])
        if stale?(category)
          response = Dto::V1::Category::Response.create(category).to_h(fields)
          render json: response, status: :ok
        end
      end

      def roots
        if params[:children].present?
          raise ActionController::BadRequest.new('children must be true or false.') unless %w(true false).include?(params[:children])
        end
        categories = Category.where(parent_id: nil).to_a
        if stale?(categories)
          response = categories.map { |category| Dto::V1::Category::Response.create(category).to_h(fields) }
          render json: response, status: :ok
        end
      end

      private

      def fields
        fields = {}
        fields[:children] = true if params[:children] == "true"
        fields
      end
    end
  end
end
