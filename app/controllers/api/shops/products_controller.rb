require_relative '../../../dtos/category_dto.rb'
require_relative '../../../dtos/characteristic_dto.rb'
require_relative '../../../dtos/error_dto.rb'
require_relative '../../../dtos/good_deal_dto.rb'
require_relative '../../../dtos/product_dto.rb'
require_relative '../../../dtos/variant_dto.rb'

module Api
  module Shops
    class ProductsController < ApplicationController
      def index
        begin
          shop = Shop.find(product_params[:shop_id])
        rescue ActiveRecord::RecordNotFound => e
          error = ErrorDto.new(e.message, 'Not Found', 404)
          return render json: error.to_json, status: :not_found
        end
        products = shop.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal])
        response = products.map {|product| ProductDto.create(product)}
        render json: response.to_json
      end

      def show
        begin 
          product = Product.find(product_params[:id])
          response = ProductDto.create(product)
        rescue ActiveRecord::RecordNotFound => e
          error = ErrorDto.new(e.message, 'Not Found', 404)
          return render json: error.to_json, status: :not_found
        end
        render json: response.to_json
      end

      def create
        unless params[:name] || !params[:name].blank?
          error = ErrorDto.new('Incorrect name', 'Bad request', 400)
          return render json: error.to_json, status: :bad_request
        end
        unless params[:categoryId] || !params[:categoryId].blank?
          error = ErrorDto.new('Incorrect category', 'Bad request', 400)
          return render json: error.to_json, status: :bad_request
        end
        unless params[:brand] || !params[:brand].blank?
          error = ErrorDto.new('Incorrect brand', 'Bad request', 400)
          
        end

        dto_product = ProductDto.new
        dto_product.id = Random.rand(1000)
        dto_product.name = params[:name]
        dto_product.slug = params[:name].parameterize
        dto_category = CategoryDto.new
        dto_category.id = params[:categoryId]
        dto_category.name = 'category'
        dto_product.category = dto_category
        dto_product.brand = params[:brand]
        dto_product.status = (params[:status] || 'not_online')
        dto_product.seller_advice = params[:sellerAdvice] if params[:sellerAdvice]
        params[:variants].each do |variant|
          dto_variant = VariantDto.new
          dto_variant.id = Random.rand(1000)
          dto_variant.weight = variant[:weight]
          dto_variant.quantity = variant[:quantity]
          dto_variant.base_price = variant[:basePrice]
          dto_variant.is_default = variant[:isDefault]
          if variant[:goodDeal]
            dto_good_deal = GoodDealDto.new
            dto_good_deal.start_at = variant[:goodDeal][:startAt]
            dto_good_deal.end_at = variant[:goodDeal][:endAt]
            dto_good_deal.discount = variant[:goodDeal][:discount]
            dto_variant.good_deal = dto_good_deal
          end
          if variant[:characteristics]
            variant[:characteristics]&.each do |characteristic|
              dto_characteristic = CharacteristicDto.new
              dto_characteristic.name = characteristic[:name]
              dto_characteristic.type = characteristic[:type]
              dto_variant.characteristics << dto_characteristic
            end
          end
          dto_product.variants << dto_variant
        end
        render json: dto_product.to_json, status: :created
      end

      def update
        unless params[:id] || params[:id].is_a?(Numeric)
          error = ErrorDto.new('Not found', 'Not found', 404)
          return render json: error.to_json, status: :bad_request
        end
        unless params[:name] || !params[:name].blank?
          error = ErrorDto.new('Incorrect name', 'Bad request', 400)
          return render json: error.to_json, status: :bad_request
        end
        unless params[:categoryId] || !params[:categoryId].blank?
          error = ErrorDto.new('Incorrect category', 'Bad request', 400)
          return render json: error.to_json, status: :bad_request
        end
        unless params[:brand] || !params[:brand].blank?
          error = ErrorDto.new('Incorrect brand', 'Bad request', 400)
          return render json: error.to_json, status: :bad_request
        end

        dto_product = ProductDto.new
        dto_product.id = params[:id].to_i
        dto_product.name = params[:name]
        dto_product.slug = params[:name].parameterize
        dto_category = CategoryDto.new
        dto_category.id = params[:categoryId]
        dto_category.name = 'category'
        dto_product.category = dto_category
        dto_product.brand = params[:brand]
        dto_product.status = (params[:status] || 'not_online')
        dto_product.seller_advice = params[:sellerAdvice] if params[:sellerAdvice]
        params[:variants].each do |variant|
          dto_variant = VariantDto.new
          dto_variant.id = Random.rand(1000)
          dto_variant.weight = variant[:weight]
          dto_variant.quantity = variant[:quantity]
          dto_variant.base_price = variant[:basePrice]
          dto_variant.is_default = variant[:isDefault]
          if variant[:goodDeal]
            dto_good_deal = GoodDealDto.new
            dto_good_deal.start_at = DateTime.now.to_date
            dto_good_deal.end_at = DateTime.now.to_date + 2
            dto_good_deal.discount = variant[:goodDeal][:discount]
            dto_variant.good_deal = dto_good_deal
          end
          if variant[:characteristics]
            variant[:characteristics]&.each do |characteristic|
              dto_characteristic = CharacteristicDto.new
              dto_characteristic.name = characteristic[:name]
              dto_characteristic.type = characteristic[:type]
              dto_variant.characteristics << dto_characteristic
            end
          end
          dto_product.variants << dto_variant
        end
        render json: dto_product.to_json, status: :ok
      end

      def destroy
        begin
          product = Product.find(product_params[:id])
          if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(product)
            product.destroy
          else
            product.soft_destroy
          end
        rescue ActiveRecord::RecordNotFound => e
          error = ErrorDto.new(e.message, 'Not Found', 404)
          return render json: error.to_json, status: :not_found
        end
        head :no_content
      end

      private

      def product_params
        params.permit(:id, :shop_id)
      end
    end
  end
end
