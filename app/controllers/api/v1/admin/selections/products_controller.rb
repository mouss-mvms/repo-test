module Api
  module V1
    module Admin
      module Selections
        class ProductsController < ApplicationController
          before_action :uncrypt_token
          before_action :retrieve_user
          before_action :verify_admin

          def index
            selection = Selection.preload(:products).find(params[:id])
            products = paginate(selection.products)

            selection_products_dtos = products.map { |product| Dto::V1::Product::Response.create(product).to_h }
            response = { products: selection_products_dtos, page: params[:page].to_i, totalPages: products.total_pages}
            render json: response, status: :ok
          end
        end
      end
    end
  end
end
