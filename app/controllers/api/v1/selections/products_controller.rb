module Api
  module V1
    module Selections
      class ProductsController < ApplicationController
        def index
          selection = Selection.preload(:products).find(params[:id])
          raise ApplicationController::Forbidden unless Selection.online.include?(selection)

          selection_dto = Dto::V1::Selection::Response.create(selection).to_h
          selection_products_dtos = selection.products.map { |product| Dto::V1::Product::Response.create(product).to_h }
          response = { selection: selection_dto, products: selection_products_dtos }
          render json: response, status: :ok
        end
      end
    end
  end
end

