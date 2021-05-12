module Api
  module Shops
    class ProductsController < ApplicationController
      def index
        begin
          shop = Shop.find(product_params[:shop_id])
        rescue ActiveRecord::RecordNotFound => e
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: :not_found
        end
        products = shop.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
        response = products.map {|product| Dto::Product::Response.create(product)}
        paginate json: response, per_page: 50
      end

      def show
        product = Product.find(product_params[:id])
        if product.present?
          response = Dto::Product::Response.create(product)
        else
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: :not_found
        end
        render json: response.to_json
      end

      def create
        unless params[:name] || !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Incorrect Name')
          return render json: error.to_h, status: :bad_request
        end
        unless Category.exists?(id: params[:category_id])
          error = Dto::Errors::BadRequest.new('Incorrect category')
          return render json: error.to_h, status: :bad_request
        end
        unless params[:brand] || !params[:brand].blank?
          error = Dto::Errors::BadRequest.new('Incorrect brand')
          return render json: error.to_h, status: :bad_request
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.create(**build_product_params.to_h.symbolize_keys)
            dto_category = Dto::Category::Request.new(::Category.where(id: params[:category_id]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product::Request.build(dto_product: dto_product, dto_category: dto_category, shop_id: product_params[:shop_id])
            response = Dto::Product::Response.create(product).to_h
            return render json: response, status: :created
          rescue => e
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          end
        end
      end

      def update
        unless params[:id] || params[:id].is_a?(Numeric)
          error = Dto::Errors::NotFound.new('Not found')
          return render json: error.to_h, status: :bad_request
        end
        unless params[:name] || !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Incorrect name')
          return render json: error.to_h, status: :bad_request
        end
        unless params[:categoryId] || !params[:categoryId].blank?
          error = Dto::Errors::BadRequest.new('Incorrect category')
          return render json: error.to_h, status: :bad_request
        end
        unless params[:brand] || !params[:brand].blank?
          error = Dto::Errors::BadRequest.new('Incorrect brand')
          return render json: error.to_h, status: :bad_request
        end

        dto_product = Dto::Product::Response.new
        dto_product.id = params[:id].to_i
        dto_product.name = params[:name]
        dto_product.slug = params[:name].parameterize
        dto_category = Dto::Category::Response.new
        dto_category.id = params[:categoryId]
        dto_category.name = 'category'
        dto_product.category = dto_category
        dto_product.brand = params[:brand]
        dto_product.status = (params[:status] || 'not_online')
        dto_product.seller_advice = params[:sellerAdvice] if params[:sellerAdvice]
        params[:variants].each do |variant|
          dto_variant = Dto::Variant::Response.new
          dto_variant.id = Random.rand(1000)
          dto_variant.weight = variant[:weight]
          dto_variant.quantity = variant[:quantity]
          dto_variant.base_price = variant[:basePrice]
          dto_variant.is_default = variant[:isDefault]
          if variant[:goodDeal]
            dto_good_deal = Dto::GoodDeal::Response.new
            dto_good_deal.start_at = DateTime.now.to_date
            dto_good_deal.end_at = DateTime.now.to_date + 2
            dto_good_deal.discount = variant[:goodDeal][:discount]
            dto_variant.good_deal = dto_good_deal
          end
          if variant[:characteristics]
            variant[:characteristics]&.each do |characteristic|
              dto_characteristic = Dto::Characteristic::Response.new
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
        product = Product.where(id: product_params[:id], shop_id: product_params[:shop_id])
        if products.present?
          product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(product)
        else
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: :not_found
        end
        head :no_content
      end

      private

      def product_params
        params.permit(:id, :shop_id)
      end

      def build_product_params
        params.permit(
          :name,
          :description,
          :brand,
          :status,
          :seller_advice,
          :is_service,
          variants: [
            :base_price,
            :weight,
            :quantity,
            :is_default,
            good_deal: [
              :start_at,
              :end_at,
              :discount
            ],
            characteristics: [
              :name,
              :type
            ]
          ]
        )
      end

      def category_product_params
        params.permit(:category_id)
      end
    end
  end
end
