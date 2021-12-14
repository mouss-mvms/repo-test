module Api
  module V1
    module Admin
      class SelectionsController < AdminsController
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
      end
    end
  end
end