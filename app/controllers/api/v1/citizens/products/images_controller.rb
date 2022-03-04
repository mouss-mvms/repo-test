module Api
  module V1
    module Citizens
      module Products
        class ImagesController < CitizensController
          def destroy
            product = @citizen.products.find(params[:product_id])
            raise ApplicationController::Forbidden.new unless product.submitted?
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