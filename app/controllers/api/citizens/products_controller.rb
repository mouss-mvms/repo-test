module Api
  module Citizens
    class ProductsController < ApplicationController
      before_action :uncrypt_token, only: :update
      before_action :retrieve_user, only: :update
      before_action :check_citizen
      before_action :check_product

      def show
        render json: Dto::Product::Response.create(@product).to_h, status: :ok
      end

      def update
        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(product_params)
            dto_category = Dto::Category::Request.new(::Category.where(id: category_product_params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: @product.shop_id, product: @product, dto_product: dto_product, dto_category: dto_category, citizen_id: @citizen.id)
            response = Dto::Product::Response.create(product).to_h
          rescue ActionController::ParameterMissing => e
            Rails.logger.error(e.message)
            error = Dto::Errors::BadRequest.new(e.message)
            return render json: error.to_h, status: error.status
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: response, status: :ok
          end
        end
      end

      private

      def check_product
        unless params[:product_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        products_citizen = Product.joins(:citizens).where("citizens.id = ?", @citizen.id)
        @product = products_citizen.where(id: params[:product_id]).first
        raise ActiveRecord::RecordNotFound.new("Couldn't find product #{params[:product_id]} for citizen #{params[:id]}") unless @product
      end

      def check_citizen
        unless params[:id].to_i > 0
          Rails.logger.error("check_citizen: Shop_id is incorrect")
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: error.status
        end
        @citizen = Citizen.find(params[:id])
      end

      def product_params
        product_params = {}
        product_params[:name] = params.require(:name)
        product_params[:description] = params.require(:description)
        product_params[:brand] = params.require(:brand)
        product_params[:status] = params.require(:status)
        product_params[:seller_advice] = params.require(:sellerAdvice)
        product_params[:is_service] = params.require(:isService)
        product_params[:citizen_advice] = params.permit(:citizenAdvice).values.first
        product_params[:image_urls] = params.permit(:imageUrls)
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

      def category_product_params
        params.permit(:categoryId)
      end
    end
  end
end
