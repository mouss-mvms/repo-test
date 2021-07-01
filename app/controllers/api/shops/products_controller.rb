module Api
  module Shops
    class ProductsController < ApplicationController
      before_action :uncrypt_token, except: [:create_offline, :update_offline, :destroy_offline, :index, :show]
      before_action :check_shop
      before_action :check_product, except: [:index, :create, :create_offline]
      before_action :retrieve_user, except: [:create_offline, :update_offline, :destroy_offline, :index, :show]
      before_action :check_user, except: [:create_offline, :update_offline, :destroy_offline, :index, :show]

      def index
        products = @shop.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
        response = products.map {|product| Dto::Product::Response.create(product)}
        paginate json: response, per_page: 50
      end

      def show
        response = Dto::Product::Response.create(@product).to_h
        render json: response
      end

      def create
        unless params[:name] && !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Name is incorrect')
          return render json: error.to_h, status: error.status
        end

        unless ::Category.exists?(id: product_params[:category_id])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{product_params[:category_id]}")
          return render json: error.to_h, status: :not_found
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(product_params)
            dto_category = Dto::Category::Request.new(::Category.where(id: product_params[:category_id]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(dto_product: dto_product, dto_category: dto_category, shop_id: route_params[:shop_id].to_i)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: response, status: :created
          end
        end
      end

      def create_offline
        unless params[:name] && !params[:name].blank?
          error = Dto::Errors::BadRequest.new('Name is incorrect')
          return render json: error.to_h, status: error.status
        end

        unless ::Category.exists?(id: product_params[:category_id])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{product_params[:category_id]}")
          return render json: error.to_h, status: :not_found
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(product_params)
            dto_category = Dto::Category::Request.new(::Category.where(id: product_params[:category_id]).select(:id, :name)&.first.as_json.symbolize_keys)
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

        unless ::Category.exists?(id: product_params[:category_id])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{product_params[:category_id]}")
          return render json: error.to_h, status: error.status
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(product_params)
            dto_category = Dto::Category::Request.new(::Category.where(id: product_params[:category_id]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: @product.shop_id, product: @product, dto_product: dto_product, dto_category: dto_category)
            response = Dto::Product::Response.create(product).to_h
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: response, status: :ok
          end
        end
      end

      def update_offline
        if product_params.blank? && product_params[:category_id].blank?
          error = Dto::Errors::BadRequest.new("The syntax of the query is incorrect: Can't update without relevant params")
          return render json: error.to_h, status: error.status
        end

        unless ::Category.exists?(id: product_params[:category_id])
          error = Dto::Errors::NotFound.new("Couldn't find Category with 'id'=#{product_params[:category_id]}")
          return render json: error.to_h, status: error.status
        end

        ActiveRecord::Base.transaction do
          begin
            dto_product = Dto::Product::Request.new(product_params)
            dto_category = Dto::Category::Request.new(::Category.where(id: product_params[:category_id]).select(:id, :name)&.first.as_json.symbolize_keys)
            product = Dto::Product.build(shop_id: @product.shop_id, product: @product, dto_product: dto_product, dto_category: dto_category)
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
        @product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(@product)
        head :no_content
      end

      def destroy_offline
        @product.destroy if ProductsSpecifications::IsRemovable.new.is_satisfied_by?(@product)
        head :no_content
      end

      private

      def check_product
        unless route_params[:id].to_i > 0
          error = Dto::Errors::BadRequest.new('Id is incorrect')
          return render json: error.to_h, status: :bad_request
        end

        begin
          @product = @shop.products.find(route_params[:id])
        rescue ActiveRecord::RecordNotFound => e
          error = Dto::Errors::NotFound.new("Couldn't find #{e.model} with 'id'=#{e.id}")
          return render json: error.to_h, status: error.status
        end
      end

      def check_shop
        unless route_params[:shop_id].to_i > 0
          error = Dto::Errors::BadRequest.new('Shop_id is incorrect')
          return render json: error.to_h, status: error.status
        end

        begin
          @shop = Shop.find(route_params[:shop_id])
        rescue ActiveRecord::RecordNotFound => e
          error = Dto::Errors::NotFound.new(e.message)
          return render json: error.to_h, status: error.status
        end
      end

      def route_params
        params.permit(:id, :shop_id)
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

      def check_user
        unless @user.is_a_pro?
          error = Dto::Errors::Forbidden.new
          return render json: error.to_h, status: error.status
        end

        unless @user.is_an_admin? || (@shop.owner == @user.shop_employee)
          error = Dto::Errors::Forbidden.new
          return render json: error.to_h, status: error.status
        end
      end
    end
  end
end
