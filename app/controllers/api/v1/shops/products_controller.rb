module Api
  module V1
    module Shops
      class ProductsController < ApplicationController
        before_action :check_shop, only: [:index]
        before_action :uncrypt_token, only: [:create]
        before_action :retrieve_user, only: [:create]
        DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services]
        PER_PAGE = 15
        QUERY_ALL = '*'

        def index
          search_criterias = ::Criterias::Composite.new(::Criterias::Products::FromShop.new(@shop.id))
                                                   .and(::Criterias::Products::Online)
          if search_params[:categories]
            category_ids = Category.where(slug: search_params[:categories].split('__')).pluck(:id).uniq
            search_criterias = search_criterias.and(::Criterias::InCategories.new(category_ids))
          end

          search_criterias = filter_by(search_criterias)
          sort_by = search_params[:sort_by] ? search_params[:sort_by] : 'position'
          sort_by = Requests::ProductSearches.new.sort_by(sort_by)
          query = search_params[:search_query] ? search_params[:search_query] : QUERY_ALL

          products = Product.search(query, where: search_criterias.create, order: sort_by, page: search_params[:page], per_page: PER_PAGE)
          response = products.map {|product| Dto::V1::Product::Response.create(product)}
          render json: response, per_page: PER_PAGE
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

        private

        def check_shop
          raise ActionController::BadRequest.new('Shop_id is incorrect') unless route_params[:id].to_i > 0
          @shop = Shop.find(route_params[:id])
        end

        def route_params
          params.permit(:id)
        end

        def search_params
          params.permit(:search_query, :categories, :prices, :services, :sort_by, :page)
        end

        def filter_by(search_criterias)
          DEFAULT_FILTERS_PRODUCTS.each do |key|
            splited_values = params[key.to_s]&.split('__')
            if splited_values
              splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
              module_name = key.to_s.titleize
              begin
                search_criterias.and("::Criterias::Products::From#{module_name}".constantize.new(splited_values))
              rescue; end
            end
          end
          search_criterias
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
