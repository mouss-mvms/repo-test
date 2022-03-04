module Api
  module V1
    module Shops
      class ImagesController < ProsController
        def destroy
          shop = @user.shops.last
          raise ApplicationController::Forbidden unless (shop.profil.id == params[:id].to_i) ||
                                                        (shop.thumbnail.id == params[:id].to_i) ||
                                                        (shop.featured.id == params[:id].to_i)
          ::Image.destroy(params[:id])
        end
      end
    end
  end
end
