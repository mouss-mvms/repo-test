module Api
  module V1
    module Products
      class VariantsController < ApplicationController
        before_action :uncrypt_token
        before_action :retrieve_user

        def destroy
          raise ApplicationController::Forbidden unless @user.is_a_business_user?
          product = Product.find(params[:product_id])
          raise ApplicationController::Forbidden if product.shop.owner != @user.shop_employee
          product.references.find(params[:id]).destroy
        end
      end
    end
  end
end
