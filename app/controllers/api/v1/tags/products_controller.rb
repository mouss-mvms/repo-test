module Api
  module V1
    module Tags
      class ProductsController < ApplicationController
        include Pagy::Backend

        DEFAULT_PER_PAGE = 15

        def index
          per_page = params[:limit] || DEFAULT_PER_PAGE
          pagination, products = pagy(Tag.find(params[:id]).products.joins(:references).distinct.order(created_at: :desc), items: per_page)
          response = { products: [], page: pagination.page, totalPages: pagination.pages, totalCount: pagination.count }
          response[:products] = products.map { |product| Dto::V1::Product::Response.create(product).to_h }
          render json: response, status: :ok
        end
      end
    end
  end
end
