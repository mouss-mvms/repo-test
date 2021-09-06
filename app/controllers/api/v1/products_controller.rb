module Api
  module V1
    class ProductsController < ApplicationController
      before_action :uncrypt_token, only: [:update, :create, :destroy]
      before_action :retrieve_user, only: [:update, :create, :destroy]
      before_action :set_location, only: [:index]

      DEFAULT_FILTERS_PRODUCTS = [:prices, :brands, :colors, :sizes, :services, :categories]

      def index
        search_criterias = ::Criterias::Composite.new(::Criterias::Products::Online)
        .and(::Criterias::Products::NotInShopTemplate)
        .and(::Criterias::NotInHolidays)

        search_criterias.and(::Criterias::Products::OnDiscount) if params[:sort_by] == 'discount'

        search_criterias.and(::Criterias::NotInCategories.new(Category.excluded_from_catalog.pluck(:id))) unless params[:q]

        if params[:categories]
          @category = Category.find_by(slug: params[:categories])
          raise ApplicationController::NotFound.new('Category not found.') unless @category
          search_criterias.and(::Criterias::InCategories.new([@category.id]))
        end

        set_close_to_you_criterias(search_criterias, params[:more])
        search_criterias = filter_by(search_criterias)

        search_highest = ::Requests::ProductSearches.search_highest_scored_products(params[:q], search_criterias)
        highest_scored_products = search_highest.products

        unless params[:sort_by] || params[:more]
          search = search_highest
          search_criterias = filter_products(search_criterias, highest_scored_products)
        end

        search_criterias.and(::Criterias::Products::ExceptProducts.new(highest_scored_products.map(&:id)))

        random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])

        unless highest_scored_products.present? && random_products.present?
          set_close_to_you_criterias(search_criterias, true)
          random_products = ::Requests::ProductSearches.search_random_products(params[:q], search_criterias, params[:sort_by], params[:page])
        end
        product_summaries = set_products!(highest_scored_products, random_products, params[:page], params[:more], params[:sort_by])

        render json: product_summaries, status: 200
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
            return render json: { url: ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
          end
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
            return render json: { url: ENV["API_BASE_URL"] + api_v1_product_job_status_path(job_id) }, status: :accepted
          end
        end
      end

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

      def set_location
        raise ActionController::ParameterMissing.new('location') if params[:location].blank?
        @territory = Territory.find_by(slug: params[:location])
        @city = City.find_by(slug: params[:location])
        raise ApplicationController::NotFound.new('Location not found.') unless @city || @territory
      end

      def set_close_to_you_criterias(search_criterias, see_more)
        insee_codes = @territory ? @territory.insee_codes : @city.insee_codes

        if see_more
          return search_criterias.and(::Criterias::CloseToYou.new(@city, insee_codes))
        else
          return set_perimeter(search_criterias, insee_codes)
        end
      end

      def set_perimeter(search_criterias, insee_codes)
        if params[:search_query] && !@category
          search_criterias.and(::Criterias::InCities.new(insee_codes))
        else
          case params[:perimeter]
          when "around_me" then search_criterias.and(::Criterias::CloseToYou.new(@city, insee_codes, current_cities_accepted: true))
          when "all" then search_criterias.and(::Criterias::HasServices.new(["livraison-par-colissimo"]))
          else search_criterias.and(::Criterias::InCities.new(insee_codes))
          end
        end

        return search_criterias
      end

      def filter_by(search_criterias)
        DEFAULT_FILTERS_PRODUCTS.each do |key|
          splited_values = params[key.to_s]&.split('__')
          if splited_values
            splited_values = splited_values.map { |value| value == "without_#{key.to_s}" ? "" : value }
            module_name = key.to_s.titleize
            begin
              search_criterias.and("::Criterias::Products::From#{module_name}".constantize.new(splited_values))
            rescue
              raise ApplicationController::InternalServerError.new
            end
          end
        end
        search_criterias
      end

      def filter_products(search_criterias, products)
        ids = products.pluck(:id).map(&:to_i)
        search_criterias.and(::Criterias::Products::ExceptProducts.new(ids))
      end

      def set_products!(highest_scored_products, random_products, page, see_more, sort_by)
        product_summaries = random_products.map { |product| Dto::V1::ProductSummary::Response.create(product.deep_symbolize_keys).to_h }
        if page || see_more || sort_by
          product_summaries
        else
          highest_scored_product_summaries = highest_scored_products.map { |product| Dto::V1::ProductSummary::Response.create(product.deep_symbolize_keys).to_h }
          highest_scored_product_summaries.concat(product_summaries)
        end
      end
    end
  end
end
