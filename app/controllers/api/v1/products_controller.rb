module Api
  module V1
    class ProductsController < ApplicationController
      before_action :uncrypt_token, only: [:update, :create, :destroy]
      before_action :retrieve_user, only: [:update, :create, :destroy]

      def update_offline
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        product = Product.find(product_params[:id])
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
        begin
          product = Dto::V1::Product.build(dto_product_request: dto_product_request, product: product)
        rescue => e
          Rails.logger.error(e)
          error = Dto::V1::Errors::InternalServer.new
          return render json: error.to_h, status: error.status
        else
          dto_product_response = Dto::V1::Product::Response.create(product)
          return render json: dto_product_response.to_h, status: :ok
        end
      end

      def update
        raise ApplicationController::Forbidden unless @user.is_a_citizen? || @user.is_a_business_user?
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        product = Product.find(product_params[:id])
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?

        if @user.is_a_citizen?
          raise ApplicationController::Forbidden if @user.citizen.products.to_a.find{ |p| p.id == product.id}.nil?
        end
        if @user.is_a_business_user?
          raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find{ |s| s.id == product.shop.id}.nil?
        end

        begin
          product = Dto::V1::Product.build(dto_product_request: dto_product_request, product: product)
        rescue => e
          Rails.logger.error(e)
          error = Dto::V1::Errors::InternalServer.new
          return render json: error.to_h, status: error.status
        else
          dto_product_response = Dto::V1::Product::Response.create(product)
          return render json: dto_product_response.to_h, status: :ok
        end
      end

      def show
        render json: Dto::V1::Product::Response.create(Product.find(params[:id])).to_h, status: :ok
      end

      def create
        raise ApplicationController::Forbidden unless @user.is_a_business_user? || @user.is_a_citizen?
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        raise ActionController::ParameterMissing.new('shopId') if dto_product_request.shop_id.blank?
        Shop.find(dto_product_request.shop_id)
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
        if @user.is_a_citizen?
          dto_product_request.status = 'submitted'
          dto_product_request.citizen_id = @user.citizen.id
        end
        ActiveRecord::Base.transaction do
          begin
            job_id = Dao::Product.create_async(dto_product_request.to_h)
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::V1::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: { url: ENV["BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
          end
        end
      end

      def create_offline
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        raise ActionController::ParameterMissing.new(dto_product_request.shop_id) if dto_product_request.shop_id.blank?
        Shop.find(dto_product_request.shop_id)
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
        ActiveRecord::Base.transaction do
          begin
            job_id = Dao::Product.create_async(dto_product_request.to_h)
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::V1::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: { url: ENV["BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
          end
        end
      end

      def destroy_offline
        Product.destroy(params[:id])
      end

      def destroy
        raise ApplicationController::Forbidden unless @user.is_a_citizen? || @user.is_a_business_user?
        product = Product.find(params[:id])
        if @user.is_a_citizen?
          raise ApplicationController::Forbidden if @user.citizen.products.to_a.find{ |p| p.id == product.id }.nil?
        end
        if @user.is_a_business_user?
          raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find{ |s| s.id == product.shop.id}.nil?
        end
        product.destroy
      end

      private

      def product_params
        product_params = {}
        product_params[:id] = params[:id]
        product_params[:name] = params.require(:name)
        product_params[:description] = params.require(:description)
        product_params[:brand] = params.require(:brand)
        product_params[:status] = params.require(:status)
        product_params[:seller_advice] = params.require(:sellerAdvice)
        product_params[:is_service] = params.require(:isService)
        product_params[:citizen_advice] = params.permit(:citizenAdvice).values.first
        product_params[:image_urls] = params[:imageUrls]
        product_params[:category_id] = params.require(:categoryId)
        product_params[:shop_id] = params[:shopId].to_i if params[:shopId]
        product_params[:allergens] = params[:allergens]
        product_params[:origin] = params[:origin]
        product_params[:composition] = params[:composition]
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
end
