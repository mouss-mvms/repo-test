module Api
  module Shops
    class ProductsController < ApplicationController
      def index
        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

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
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end

        product = Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{route_params[:id]}")
          return render json: error.to_h, status: :not_found
        end

        response = Dto::Product::Response.create(product).to_h
        render json: response
      end

      def create
        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless params[:name] && !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Name is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{category_product_params[:categoryId]}")
          return render json: error.to_h, status: :not_found
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end


        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(dto_product: dto_product, dto_category: dto_category, shop_id: route_params[:shop_id].to_i)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          else
            return render json: response, status: :created
          end
        end
      end

      def create_offline
        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless params[:name] && !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Name is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{category_product_params[:categoryId]}")
          return render json: error.to_h, status: :not_found
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end


        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(dto_product: dto_product, dto_category: dto_category, shop_id: route_params[:shop_id].to_i)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          else
            return render json: response, status: :created
          end
        end
      end

      def update
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        if product_params.blank? && category_product_params.blank?
          error = Dto::Errors::BadRequest.new("The syntax of the query is incorrect: Can't update without relevant params")
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{category_product_params[:categoryId]}")
          return render json: error.to_h, status: :not_found
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end

        product = ::Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{route_params[:id]}")
          return render json: error.to_h, status: :not_found
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: category_product_params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: product.shop_id, product: product, dto_product: dto_product, dto_category: dto_category)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          else
            return render json: response, status: :ok
          end
        end
      end

      def update_offline
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        if product_params.blank? && category_product_params.blank?
          error = Dto::Errors::BadRequest.new("The syntax of the query is incorrect: Can't update without relevant params")
          return render json: error.to_h, status: :bad_request
        end

        unless ::Category.exists?(id: category_product_params[:categoryId])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{category_product_params[:categoryId]}")
          return render json: error.to_h, status: :not_found
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end

        product = ::Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{route_params[:id]}")
          return render json: error.to_h, status: :not_found
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(permitted_params_to_underscore(product_params))
            dto_category = Dto::Category::Request.new(::Category.where(id: category_product_params[:categoryId]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: product.shop_id, product: product, dto_product: dto_product, dto_category: dto_category)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: :internal_server_error
          else
            return render json: response, status: :ok
          end
        end
      end

      def destroy
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end

        product = Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{route_params[:id]}")
          return render json: error.to_h, status: :not_found
        end

        product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(product)

        head :no_content
      end

      def destroy_offline
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        unless ::Shop.exists?(id: route_params[:shop_id])
          error = Dto::Errors::NotFound.new("Couldn't find Shop with 'id'=#{route_params[:shop_id]}")
          return render json: error.to_h, status: :not_found
        end

        product = Product.where(route_params).first

        unless product
          error = Dto::Errors::NotFound.new("Couldn't find Product with 'id'=#{route_params[:id]}")
          return render json: error.to_h, status: :not_found
        end

        product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(product)

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
