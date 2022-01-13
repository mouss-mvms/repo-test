module Api
  module V1
    module Shops
      class ProductsController < ApplicationController
        include Pagy::Backend

        before_action :uncrypt_token
        before_action :retrieve_user
        DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services]
        PER_PAGE = 15

        def index
          raise ApplicationController::Forbidden unless @user.is_a_business_user?

          shop = @user.shops.last
          raise ApplicationController::NotFound.new("Shop not found for this user") if shop.nil?

          if params[:status].present?
            raise ActionController::BadRequest.new("Status is incorrect") unless Product.statuses.keys.include?(params[:status])
            status = params[:status]
          else
            status = [:offline, :online]
          end

          pagination, products = pagy(shop.products.where(status: status)
                                          .where("lower(products.name) LIKE ?", params[:name] ? "%#{params[:name].downcase}%" : '%')
                                          .joins(:category)
                                          .where("lower(categories.name) LIKE ?", params[:category] ? "%#{params[:category].downcase}%" : '%'),
                                      {page: (params[:page] || 1), items: (params[:limit] || PER_PAGE) })

          if stale?(products)
            response = products.map{ |product| Dto::V1::Product::Response::create(product)}
            render json: { products: response, page: pagination.page, totalPages: pagination.pages, totalCount: pagination.count }, status: :ok
          end
        end

        def create
          raise ApplicationController::Forbidden unless @user.is_a_business_user?
          dto_product_request = Dto::V1::Product::Request.new(product_params)
          raise ActionController::ParameterMissing.new('shopId') if dto_product_request.shop_id.blank?
          shop = Shop.find(dto_product_request.shop_id)
          category = Category.find(dto_product_request.category_id)
          raise ActionController::BadRequest.new('origin and composition is required') if ::Products::CategoriesSpecifications::MustHaveLabelling.new.is_satisfied_by?(category) && (dto_product_request.origin.blank? || dto_product_request.composition.blank?)
          raise ActionController::BadRequest.new('allergens is required') if ::Products::CategoriesSpecifications::HasAllergens.new.is_satisfied_by?(category) && dto_product_request.allergens.blank?
          raise ApplicationController::Forbidden.new("You could not create a product for this shop.") unless @user.shops.include?(shop)
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

        def update
          raise ApplicationController::Forbidden.new unless @user.is_a_business_user?
          dto_product_request = Dto::V1::Product::Request.new(product_params_update)
          raise ApplicationController::Forbidden.new if dto_product_request.citizen_advice
          @user.shop_employee.shops.last.products.find(dto_product_request.id)
          begin
            product = Dao::Product.update(dto_product_request: dto_product_request)
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error(e.message)
            error = Dto::Errors::NotFound.new(e.message)
            return render json: error.to_h, status: error.status
          rescue => e
            Rails.logger.error(e.message)
            error = Dto::Errors::InternalServer.new(detail: e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: Dto::V1::Product::Response.create(product).to_h, status: :ok
          end
        end

        private

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
            params[:variants].each do |v|
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
              end
              if v[:goodDeal]
                hash[:good_deal] = {}
                hash[:good_deal][:start_at] = v[:goodDeal].require(:startAt)
                hash[:good_deal][:end_at] = v[:goodDeal].require(:endAt)
                hash[:good_deal][:discount] = v[:goodDeal].require(:discount)
              end
              product_params[:variants] << hash
            end
          end
          product_params
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
            product_params[:variants] << hash
          }
          product_params
        end
      end
    end
  end
end
