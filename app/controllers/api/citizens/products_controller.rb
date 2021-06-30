module Api
  module Citizens
    class ProductsController < ApplicationController
      def show
        citizen = Citizen.find(params[:id])
        products_citizen = Product.joins(:citizens).where("citizens.id = ?", citizen.id)
        product = products_citizen.where(id: params[:product_id]).first
        raise ActiveRecord::RecordNotFound unless product
        return render json: Dto::Product::Response.create(product).to_h, status: :ok
      end
    end
  end
end
