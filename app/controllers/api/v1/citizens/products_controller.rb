module Api
  module V1
    module Citizens
      class ProductsController < ApplicationController
        before_action :check_citizen, only: [:index]
        before_action :uncrypt_token, only: [:create]
        before_action :retrieve_user, only: [:create]

        def index
          products = @citizen.products.includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives
          response = products.map {|product| Dto::V1::Product::Response.create(product)}
          render json: response, status: :ok
        end

        def create
          raise ApplicationController::Forbidden unless @user.is_a_citizen?
          dto_product_request = Dto::V1::Product::Request.new(product_params)
          raise ActionController::ParameterMissing.new('shopId') if dto_product_request.shop_id.blank?
          Shop.find(dto_product_request.shop_id)
          category = Category.find(dto_product_request.category_id)
          raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
          raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
          dto_product_request.status = 'submitted'
          dto_product_request.citizen_id = @user.citizen.id
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

        private

        def check_citizen
          raise ApplicationController::UnpermittedParameter unless params[:id].to_i > 0

          @citizen = Citizen.find(params[:id])
        end

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
            product_params[:variants] << hash
          }
          product_params
        end
      end
    end
  end
end
