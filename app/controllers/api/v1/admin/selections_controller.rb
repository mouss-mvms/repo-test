module Api
  module V1
    module Admin
      class SelectionsController < ApplicationController
        before_action :uncrypt_token
        before_action :retrieve_user
        before_action :verify_admin

        def index
          params[:page] ||= 1
          selections = Selection.page(params[:page])
          selection_responses = selections.map { |selection| Dto::V1::Selection::Response.create(selection).to_h }
          response = { selections: selection_responses, page: params[:page].to_i, totalPages: selections.total_pages }
          render json: response, status: :ok
        end

        def show
          selection = Selection.find(params[:id])
          response = Dto::V1::Selection::Response.create(selection).to_h
          render json: response, status: :ok
        end

        private

        def verify_admin
          raise ApplicationController::Forbidden unless @user.is_an_admin?
        end
      end
    end
  end
end