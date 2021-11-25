module Api
  module V1
    module Selections
      class ProductsController < ApplicationController
        before_action :uncrypt_token
        before_action :retrieve_user
        before_action :check_authorization
        before_action :find_selection
        before_action :find_product

        def add
          raise ApplicationController::UnprocessableEntity.new("Product already in selection.") if @selection.products.include?(@product)
          @selection.products << @product
          @selection.save!
          render json: Dto::V1::Selection::Response.create(@selection).to_h, status: :ok
        end

        def remove
          @selection.products.delete(@product)
          @selection.save!
          render json: Dto::V1::Selection::Response.create(@selection).to_h, status: :ok
        end

        private

        def find_selection
          @selection = Selection.find(params[:selection_id])
        end

        def find_product
          @product = Product.find(params[:id])
        end

        def check_authorization
          raise ApplicationController::Forbidden.new("User isn't a admin.") unless @user.is_an_admin?
        end
      end
    end
  end
end
