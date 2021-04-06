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
        dto_product1 = ProductDto.new
        dto_product1.id = Random.rand(1000)
        dto_product1.name = 'Product name'
        dto_product1.slug = 'product-name'
        dto_category = CategoryDto.new
        dto_category.id = Random.rand(12)
        dto_category.name = 'category'
        dto_product1.category = dto_category
        dto_product1.brand = 'brand'
        dto_product1.status = 'active'
        dto_product1.seller_advice = 'Bon produit'
        dto_variant1 = VariantDto.new
        dto_variant1.id = 23
        dto_variant1.weight = 12.8
        dto_variant1.quantity = 23
        dto_variant1.base_price = 15
        dto_variant1.is_default = true
        dto_good_deal = GoodDealDto.new
        dto_good_deal.start_at = DateTime.now.to_date
        dto_good_deal.end_at = DateTime.now.to_date + 2
        dto_good_deal.discount = 20
        dto_variant1.good_deal = dto_good_deal
        dto_characteristic = CharacteristicDto.new
        dto_characteristic.name = 'blue'
        dto_characteristic.type = 'color'
        dto_variant1.characteristics << dto_characteristic
        dto_product1.variants << dto_variant1

        dto_product2 = ProductDto.new
        dto_product2.id = Random.rand(1000)
        dto_product2.name = 'Product name'
        dto_product2.slug = 'product-name'
        dto_category = CategoryDto.new
        dto_category.id = Random.rand(12)
        dto_category.name = 'category'
        dto_product2.category = dto_category
        dto_product2.brand = 'brand'
        dto_product2.status = 'active'
        dto_product2.seller_advice = 'Bon produit'
        dto_variant2 = VariantDto.new
        dto_variant2.id = 23
        dto_variant2.weight = 12.8
        dto_variant2.quantity = 23
        dto_variant2.base_price = 15
        dto_variant2.is_default = true
        dto_characteristic = CharacteristicDto.new
        dto_characteristic.name = 'blue'
        dto_characteristic.type = 'color'
        dto_variant2.characteristics << dto_characteristic
        dto_product2.variants << dto_variant2
        products = []
        products << dto_product1
        products << dto_product2
        render json: products.to_json
      end

      def show
        id = params[:id]
        dto_product = ProductDto.new
        dto_product.id = id.to_i
        dto_product.name = 'Product name'
        dto_product.slug = 'product-name'
        dto_category = CategoryDto.new
        dto_category.id = Random.rand(12)
        dto_category.name = 'category'
        dto_product.category = dto_category
        dto_product.brand = 'brand'
        dto_product.status = 'active'
        dto_product.seller_advice = 'Bon produit'
        dto_variant = VariantDto.new
        dto_variant.id = 23
        dto_variant.weight = 12.8
        dto_variant.quantity = 23
        dto_variant.base_price = 15
        dto_variant.is_default = true
        dto_good_deal = GoodDealDto.new
        dto_good_deal.start_at = DateTime.now.to_date
        dto_good_deal.end_at = DateTime.now.to_date + 2
        dto_good_deal.discount = 20
        dto_variant.good_deal = dto_good_deal
        dto_characteristic = CharacteristicDto.new
        dto_characteristic.name = 'blue'
        dto_characteristic.type = 'color'
        dto_variant.characteristics << dto_characteristic
        dto_product.variants << dto_variant
        render json: dto_product.to_json
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
          return render json: error.to_json, status: :bad_request
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
        unless params[:id] || params[:id].is_a?(Numeric)
          error = ErrorDto.new('Not found', 'Not found', 404)
          return render json: error.to_json, status: :bad_request
        end

        head :no_content
      end
    end
  end
end
