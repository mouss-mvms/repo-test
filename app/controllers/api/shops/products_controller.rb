module Api
  module Shops
    class ProductsController < ApplicationController
      def index
        begin
          shop = Shop.find(route_params[:shop_id])
        rescue ActiveRecord::RecordNotFound => e
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: :not_found
        end
        products = shop.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
        response = products.map {|product| Dto::Product::Response.create(product)}
        paginate json: response, per_page: 50
      end

      def show
        product = Product.where(route_params).first
        if product.present?
          response = Dto::Product::Response.create(product)
        else
          error = Dto::Errors::NotFound.new('Not Found')
          return render json: error.to_h, status: :not_found
        end
        render json: response.to_json
      end

      def create
        unless params[:name] || !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Incorrect Name')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::BadRequest.new('Incorrect category')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::BadRequest.new('Incorrect shop')
          return render json: error.to_h, status: :bad_request
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.create(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(dto_product: dto_product, dto_category: dto_category, shop_id: route_params[:shop_id].to_i)
            response = Dto::Product::Response.create(product).to_h
            return render json: response, status: :created
          rescue => e
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          end
        end
      end

      def update
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('The syntax of the query is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('The syntax of the query is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        if product_params.blank? && category_product_params.blank?
          error = Dto::Errors::BadRequest.new("The syntax of the query is incorrect: Can't update without relevant params")
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::NotFound.new('Category not found')
          return render json: error.to_h, status: :not_found
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new('Shop not found')
          return render json: error.to_h, status: :not_found
        end

        product = ::Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new('Product not found')
          return render json: error.to_h, status: :not_found
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.create(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: category_product_params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: product.shop_id, product: product, dto_product: dto_product, dto_category: dto_category)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          end
          return render json: response, status: :ok
        end
      end

      def destroy
        product = Product.where(id: route_params[:id], shop_id: route_params[:shop_id]).first
        if product.present?
          product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(product)
        else
          error = Dto::Errors::NotFound.new('Not Found')
          return render json: error.to_h, status: :not_found
        end
        head :no_content
      end

      private
      def permitted_params_to_underscore(params)
        params.to_h.deep_transform_keys { |key| key.to_s.underscore.to_sym }
      end

      def route_params
        params.permit(:id, :shop_id)
      end

      def product_params
        params.permit(
          :name,
          :description,
          :brand,
          :status,
          :sellerAdvice,
          :isService,
          variants: [
            :basePrice,
            :weight,
            :quantity,
            :isDefault,
            goodDeal: [
              :startAt,
              :endAt,
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
        params.permit(:categoryId)
      end
    end
  end
end
