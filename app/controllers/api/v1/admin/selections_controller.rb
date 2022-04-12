module Api
  module V1
    module Admin
      class SelectionsController < AdminsController
        def index
          params[:page] ||= Pagy::DEFAULT[:page]
          params[:limit] ||= Pagy::DEFAULT[:items].to_i
          pagination, selections = pagy(Selection, items: params[:limit])
          selection_responses = selections.order(id: :desc).map { |selection| Dto::V1::Selection::Response.create(selection).to_h }
          response = { selections: selection_responses, page: pagination.page, totalCount: pagination.count, totalPages: pagination.pages }
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