module Api
  class ProductsController < ApplicationController
    before_action :uncrypt_token, only: [:update]
    before_action :retrieve_user, only: [:update]

    def update_offline
      product = Product.find(product_params[:id])
      Category.find(product_params[:category_id])
      begin
        dto_product_request = Dto::Product::Request.new(product_params)
        product = Dto::Product.build(dto_product_request: dto_product_request, product: product)
      rescue => e
        Rails.logger.error(e)
        error = Dto::Errors::InternalServer.new
        return render json: error.to_h, status: error.status
      else
        dto_product_response = Dto::Product::Response.create(product)
        return render json: dto_product_response.to_h, status: :ok
      end
    end

    def update
      raise ApplicationController::Forbidden unless @user.is_a_citizen? || @user.is_a_business_user?
      product = Product.find(product_params[:id])
      Category.find(product_params[:category_id])
      if @user.is_a_citizen?
        raise ApplicationController::Forbidden if @user.citizen.products.to_a.find{ |p| p.id == product.id}.nil?
      end
      if @user.is_a_business_user?
        raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find{ |s| s.id == product.shop.id}.nil?
      end
      begin
        dto_product_request = Dto::Product::Request.new(product_params)
        product = Dto::Product.build(dto_product_request: dto_product_request, product: product)
      rescue => e
        Rails.logger.error(e)
        error = Dto::Errors::InternalServer.new
        return render json: error.to_h, status: error.status
      else
        dto_product_response = Dto::Product::Response.create(product)
        return render json: dto_product_response.to_h, status: :ok
      end
    end

    private

    def product_params
      product_params = {}
      product_params[:id] = params.require(:id)
      product_params[:name] = params.require(:name)
      product_params[:description] = params.require(:description)
      product_params[:brand] = params.require(:brand)
      product_params[:status] = params.require(:status)
      product_params[:seller_advice] = params.require(:sellerAdvice)
      product_params[:is_service] = params.require(:isService)
      product_params[:citizen_advice] = params.permit(:citizenAdvice).values.first
      product_params[:image_urls] = params.permit(:imageUrls)
      product_params[:category_id] = params.require(:categoryId)
      product_params[:variants] = []
      params.require(:variants).each { |v|
        hash = {}
        hash[:base_price] = v.require(:basePrice)
        hash[:weight] = v.require(:weight)
        hash[:quantity] = v.require(:quantity)
        hash[:is_default] = v.require(:isDefault)
        if v[:goodDeal]
          hash[:good_deal] = {}
          hash[:good_deal][:start_at] = v[:goodDeal].require(:startAt)
          hash[:good_deal][:end_at] = v[:goodDeal].require(:endAt)
          hash[:good_deal][:discount] = v[:goodDeal].require(:discount)
        end
        hash[:characteristics] = []
        v.require(:characteristics).each { |c|
          characteristic = {}
          characteristic[:name] = c.require(:name)
          characteristic[:value] = c.require(:value)
          hash[:characteristics] << characteristic
        }
        product_params[:variants] << hash
      }
      product_params
    end

  end
end