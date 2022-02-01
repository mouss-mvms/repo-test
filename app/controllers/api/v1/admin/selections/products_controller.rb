module Api
  module V1
    module Admin
      module Selections
        class ProductsController < AdminsController
          include Pagy::Backend

          def index
            selection = Selection.preload(:products).find(params[:id])
            pagination, products = pagy(selection.products, items: params[:limit] || 16)

            selection_products_dtos = products.map { |product| Dto::V1::Product::Response.create(product).to_h }
            response = { products: selection_products_dtos, page: pagination.page, totalPages: pagination.pages, totalCount: pagination.count }
            render json: response, status: :ok
          end
        end
      end
    end
  end
end
