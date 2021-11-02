module Api
  module V1
    class ProductsController < ApplicationController
      before_action :uncrypt_token, only: [:update, :create, :destroy, :patch_auth]
      before_action :retrieve_user, only: [:update, :create, :destroy, :patch_auth]

      def show
        render json: Dto::V1::Product::Response.create(Product.find(params[:id])).to_h, status: :ok
      end

      def update
        raise ApplicationController::Forbidden unless @user.is_a_citizen? || @user.is_a_business_user?
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        product = Product.find(product_params[:id])
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?

        if @user.is_a_citizen?
          raise ApplicationController::Forbidden if @user.citizen.products.to_a.find { |p| p.id == product.id }.nil?
        end
        if @user.is_a_business_user?
          raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find { |s| s.id == product.shop.id }.nil?
        end

        begin
          product = Dto::V1::Product.build(dto_product_request: dto_product_request, product: product)
        rescue => e
          Rails.logger.error(e)
          error = Dto::Errors::InternalServer.new
          return render json: error.to_h, status: error.status
        else
          dto_product_response = Dto::V1::Product::Response.create(product)
          return render json: dto_product_response.to_h, status: :ok
        end
      end

      def patch_auth
        ActiveRecord::Base.transaction do
          raise ApplicationController::Forbidden.new unless @user.is_a_business_user?
          dto_product_request = Dto::V1::Product::Request.new(product_params_update)
          product = Product.find(dto_product_request.id)
          category = Category.find(dto_product_request.category_id) if dto_product_request.category_id.present?
          if category
            raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
            raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
          end
          raise ApplicationController::Forbidden.new("You could not create a product for this shop.") unless @user.shops.include?(product.shop)
          begin
            product = Dao::Product.update(dto_product_request: dto_product_request)
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: Dto::V1::Product::Response.create(product), status: :ok
          end
        end
      end

      def patch
        ActiveRecord::Base.transaction do
          if product_params[:provider] && product_params[:provider][:name] == 'wynd'
            raise ActionController::ParameterMissing.new('provider.externalProductId') unless product_params[:provider][:external_product_id]
          end
          product_params[:variants].each do |variant|
            if variant[:provider] && variant[:provider][:name] == 'wynd'
              raise ActionController::ParameterMissing.new('variant.provider.externalVariantId') unless variant[:provider][:external_variant_id]
            end
          end
          dto_product_request = Dto::V1::Product::Request.new(product_params_update)
          product = Product.find(dto_product_request.id)
          category = Category.find(dto_product_request.category_id) if dto_product_request.category_id.present?
          if category
            raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
            raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
          end
          begin
            product = Dao::Product.update(dto_product_request: dto_product_request)
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: Dto::V1::Product::Response.create(product), status: :ok
          end
        end
      end

      def destroy
        raise ApplicationController::Forbidden unless @user.is_a_citizen? || @user.is_a_business_user?
        product = Product.find(params[:id])
        if @user.is_a_citizen?
          raise ApplicationController::Forbidden if @user.citizen.products.to_a.find { |p| p.id == product.id }.nil?
        end
        if @user.is_a_business_user?
          raise ApplicationController::Forbidden if @user.shop_employee.shops.to_a.find { |s| s.id == product.shop.id }.nil?
        end
        product.destroy
      end

      def create_offline
        raise ActionController::ParameterMissing.new('provider') unless product_params[:provider]
        if product_params[:provider][:name] == 'wynd'
          raise ActionController::ParameterMissing.new('provider.externalProductId') unless product_params[:provider][:external_product_id]
        end
        product_params[:variants].each do |req_variant|
          raise ActionController::ParameterMissing.new('variant.externalVariantId') unless req_variant[:external_variant_id]
        end
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
            error = Dto::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: { url: ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
          end
        end
      end

      def update_offline
        if product_params[:provider] && product_params[:provider][:name] == 'wynd'
          raise ActionController::ParameterMissing.new('provider.externalProductId') unless product_params[:provider][:external_product_id]
        end
        product_params[:variants].each do |variant|
          if variant[:provider] && variant[:provider][:name] == 'wynd'
            raise ActionController::ParameterMissing.new('variant.provider.externalVariantId') unless variant[:provider][:external_variant_id]
          end
        end
        dto_product_request = Dto::V1::Product::Request.new(product_params)
        product = Product.find(product_params[:id])
        category = Category.find(dto_product_request.category_id)
        raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
        raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
        begin
          product = Dto::V1::Product.build(dto_product_request: dto_product_request, product: product)
        rescue => e
          Rails.logger.error(e)
          error = Dto::Errors::InternalServer.new
          return render json: error.to_h, status: error.status
        else
          dto_product_response = Dto::V1::Product::Response.create(product)
          return render json: dto_product_response.to_h, status: :ok
        end
      end

      def destroy_offline
        Product.destroy(params[:id])
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
        #product_params[:image_urls] = params[:imageUrls]
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
          hash[:image_urls] = v[:imageUrls]
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
          hash[:external_variant_id] = v[:externalVariantId] if v[:externalVariantId]
          product_params[:variants] << hash
        }
        if params[:provider]
          product_params[:provider] = {}
          product_params[:provider][:name] = params[:provider][:name] if params[:provider][:name]
          product_params[:provider][:external_product_id] = params[:provider][:externalProductId] if params[:provider][:externalProductId]
        end
        product_params
      end

      def product_params_update
        product_params = {}
        product_params[:id] = params[:id]
        product_params[:name] = params[:name]
        product_params[:description] = params[:description]
        product_params[:brand] = params[:brand]
        product_params[:status] = params[:status]
        product_params[:seller_advice] = params[:sellerAdvice]
        product_params[:is_service] = params[:isService]
        product_params[:category_id] = params[:categoryId]
        product_params[:allergens] = params[:allergens]
        product_params[:origin] = params[:origin]
        product_params[:composition] = params[:composition]
        product_params[:variants] = []
        if params[:variants]
          params[:variants].each { |v|
            hash = {}
            if v[:id]
              hash[:id] = v[:id]
              hash[:base_price] = v[:basePrice]
              hash[:weight] = v[:weight]
              hash[:quantity] = v[:quantity]
              hash[:is_default] = v[:isDefault]
              hash[:image_urls] = v[:imageUrls]
              hash[:characteristics] = []
              if v[:characteristics]
                v.require(:characteristics).each { |c|
                  characteristic = {}
                  characteristic[:name] = c.require(:name)
                  characteristic[:value] = c.require(:value)
                  hash[:characteristics] << characteristic
                }
              end
              hash[:external_variant_id] = v[:externalVariantId]
              hash
            else
              hash[:base_price] = v.require(:basePrice)
              hash[:weight] = v.require(:weight)
              hash[:quantity] = v.require(:quantity)
              hash[:is_default] = v.require(:isDefault)
              hash[:image_urls] = v[:imageUrls]
              hash[:characteristics] = []
              v.require(:characteristics).each { |c|
                characteristic = {}
                characteristic[:name] = c.require(:name)
                characteristic[:value] = c.require(:value)
                hash[:characteristics] << characteristic
              }
              hash[:external_variant_id] = v[:externalVariantId] if v[:externalVariantId]
            end
            if v[:goodDeal]
              hash[:good_deal] = {}
              hash[:good_deal][:start_at] = v[:goodDeal].require(:startAt)
              hash[:good_deal][:end_at] = v[:goodDeal].require(:endAt)
              hash[:good_deal][:discount] = v[:goodDeal].require(:discount)
            end
            product_params[:variants] << hash
          }
        end

        if params[:provider]
          product_params[:provider] = {}
          product_params[:provider][:name] = params[:provider][:name] if params[:provider][:name]
          product_params[:provider][:external_product_id] = params[:provider][:externalProductId] if params[:provider][:externalProductId]
        end
        product_params
      end
    end
  end
end
