module Api
  module V1
    module Shops
      module Products
        class ImagesController < ProsController
          def destroy
            raise ApplicationController::Forbidden.new unless @user.is_a_pro?
            shop = @user.shop_employee.shops.last
            raise ApplicationController::UnprocessableEntity.new unless shop
            product = shop.products.find(params[:product_id])
            raise ApplicationController::Forbidden.new unless ["offline", "online", "submitted"].include?(product.status)
            samples = product.samples
            image = Image.where(id: params[:id], sample_id: [samples.map(&:id)]).first
            raise ApplicationController::NotFound.new("Could not find Image with id: #{params[:id]} for product_id: #{params[:product_id]}") unless image
            image.destroy
          end
        end
      end
    end
  end
end