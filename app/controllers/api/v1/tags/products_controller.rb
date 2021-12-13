module Api
  module V1
    module Tags
      class ProductsController < ApplicationController

        DEFAULT_PER_PAGE = 15

        def index
          page = params[:page].to_i || 1
          per_page = params[:limit] || DEFAULT_PER_PAGE
          products = Kaminari.paginate_array(Tag.find(params[:id]).products.order(created_at: :desc).to_a).page(page).per(per_page)
          response = { products: [], page: page, totalPages: products.total_pages}
          response[:products] = products.map { |product| Dto::V1::Product::Response.create(product).to_h }
          render json: response, status: :ok
        end
      end
    end
  end
end
