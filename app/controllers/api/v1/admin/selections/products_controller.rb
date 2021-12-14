module Api
  module V1
    module Admin
      module Selections
        class ProductsController < AdminsController
          def index
            params[:page] ||= 1
            selection = Selection.preload(:products).find(params[:id])
            products = Kaminari.paginate_array(selection.products).page(params[:page])

            selection_products_dtos = products.map { |product| Dto::V1::Product::Response.create(product).to_h }
            response = { products: selection_products_dtos, page: params[:page].to_i, totalPages: products.total_pages}
            render json: response, status: :ok
          end
        end
      end
    end
  end
end
