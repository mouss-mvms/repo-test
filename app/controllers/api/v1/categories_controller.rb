module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :check_params_children

      def show
        category = Category.search("*", { where: { id: params[:id] }, load: false })
        raise ApplicationController::NotFound unless category.hits.present?
        response = Dto::V1::CategorySummary::Response.create(category.map { |c| c }.first, fields).to_h(fields)
        render json: response, status: :ok
      end

      def roots
        categories = Category.search("*", { where: { parent_id: nil }, load: false })
        response = categories.map { |category| Dto::V1::CategorySummary::Response.create(category, fields).to_h(fields) }
        render json: response, status: :ok
      end

      private

      def check_params_children
        if params[:children].present?
          raise ActionController::BadRequest.new('children must be true or false.') unless %w(true false).include?(params[:children])
        end
      end

      def fields
        fields = {}
        fields[:children] = true if params[:children] == "true"
        fields
      end
    end
  end
end
