module Api
  module V1
    module Citizens
      class ProductsController < ApplicationController
        before_action :check_citizen

        def index
          products = @citizen.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
          response = products.map {|product| Dto::V1::Product::Response.create(product)}
          render json: response, status: :ok
        end

        private

        def check_citizen
          raise ApplicationController::UnpermittedParameter unless params[:id].to_i > 0

          @citizen = Citizen.find(params[:id])
        end
      end
    end
  end
end
