module Api
  module V1
    module Citizens
      class ProductsController < ApplicationController
        before_action :check_citizen, only: [:index]
        before_action :uncrypt_token, only: [:create, :update]
        before_action :retrieve_user, only: [:create, :update]

        PER_PAGE = 16

        def index
          order = [params[:sort_by].split('-')].to_h if params[:sort_by]
          page = params[:page] ? params[:page].to_i : 1
          limit = params[:limit] || PER_PAGE
          products = Kaminari.paginate_array(@citizen.products.order(order).includes(:category, :brand, references: [:sample, :color, :size, :good_deal]).actives).page(page).per(limit)
          if stale?(products)
            response = {
              products: products.map { |product| Dto::V1::Product::Response.create(product).to_h },
              page: products.current_page,
              totalPages: products.total_pages,
              totalCount: products.total_count
            }
            return render json: response, status: :ok
          end
        end

        def create
          raise ApplicationController::Forbidden unless @user.is_a_citizen?
          dto_product_request = Dto::V1::Product::Request.new(product_params)
          raise ActionController::ParameterMissing.new('shopId') if dto_product_request.shop_id.blank?
          Shop.find(dto_product_request.shop_id)
          category = Category.find(dto_product_request.category_id)
          dto_product_request.status = 'submitted'
          dto_product_request.citizen_id = @user.citizen.id
          job_id = Dao::Product.create_async(dto_product_request.to_h)
          return render json: { url: ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
        end

        def update
          raise ApplicationController::Forbidden.new unless @user.is_a_citizen?
          dto_product_request = Dto::V1::Product::Request.new(product_params_update)
          product = @user.citizen.products.find(dto_product_request.id)
          raise ApplicationController::Forbidden.new unless (product.status == "submitted" || product.status == "refused")
          raise ApplicationController::Forbidden.new if dto_product_request.status
          begin
            product = Dao::Product.update(dto_product_request: dto_product_request)
          rescue ActiveRecord::RecordNotFound => e
            Rails.logger.error(e.message)
            error = Dto::Errors::NotFound.new(e.message)
            return render json: error.to_h, status: error.status
          else
            return render json: Dto::V1::Product::Response.create(product).to_h, status: :ok
          end
        end

        private

        def check_citizen
          raise ApplicationController::UnpermittedParameter unless params[:id].to_i > 0

          @citizen = Citizen.find(params[:id])
        end

        def product_params_update
          product_params = {}
          product_params[:id] = params[:id]
          product_params[:name] = params[:name]
          product_params[:brand] = params[:brand]
          product_params[:status] = params[:status]
          product_params[:citizen_advice] = params[:citizenAdvice]
          product_params[:is_service] = params[:isService]
          product_params[:variants] = []
          if params[:variants]
            params[:variants].each do |v|
              hash = {}
              raise ActionController::BadRequest.new("You can only pass imageIds or imageUrls, not both.") if v[:imageIds] && v[:imageUrls]
              if params[:imageIds] || params[:imageUrls]
                image_urls = params[:imageUrls] ? params[:imageUrls] : params[:imageIds].map { |id| Image.find(id).file_url }
              end
              if v[:id]
                hash[:id] = v[:id]
                hash[:base_price] = v[:basePrice]
                hash[:image_urls] = image_urls
                hash
              else
                hash[:base_price] = v.require(:basePrice)
                hash[:image_urls] = image_urls
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
          product_params[:description] = params[:description]
          product_params[:brand] = params[:brand]
          product_params[:status] = params[:status]
          product_params[:seller_advice] = params[:sellerAdvice]
          product_params[:is_service] = params[:isService]
          product_params[:citizen_advice] = params.require(:citizenAdvice)
          product_params[:category_id] = params[:categoryId] || Category.find_by(slug: 'non-classee').id
          product_params[:shop_id] = params.require(:shopId)
          product_params[:allergens] = params[:allergens]
          product_params[:origin] = params[:origin]
          product_params[:composition] = params[:composition]
          product_params[:variants] = []
          params.require(:variants).each { |v|
            hash = {}
            hash[:base_price] = v[:basePrice] || 0.0
            hash[:weight] = v[:weight]
            hash[:quantity] = v[:quantity] || 0
            hash[:is_default] = v[:isDefault]
            raise ActionController::ParameterMissing.new("imageIds or imageUrls") unless v[:imageIds] || v[:imageUrls]
            raise ActionController::BadRequest.new("You can only pass imageIds or imageUrls, not both.") if v[:imageIds] && v[:imageUrls]
            if v[:imageIds] && v[:imageIds].count <= 5
              hash[:image_ids] = v.require(:imageIds) if v[:imageIds].each { |id| Image.find(id) }
            elsif v[:imageUrls] && v[:imageUrls].count <= 5
              hash[:image_urls] = v.require(:imageUrls)
            else
              raise ActionController::BadRequest.new("You can't pass more than 5 image ids")
            end

            if v[:goodDeal]
              hash[:good_deal] = {}
              hash[:good_deal][:start_at] = v[:goodDeal][:startAt]
              hash[:good_deal][:end_at] = v[:goodDeal][:endAt]
              hash[:good_deal][:discount] = v[:goodDeal][:discount]
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
